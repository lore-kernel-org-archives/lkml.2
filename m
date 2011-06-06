Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1FFRIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:08:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:27335 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1FFRId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:08:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="7932237"
Message-ID: <4DED0990.8090309@linux.intel.com>
Date: Mon, 06 Jun 2011 10:08:32 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jean Sacren <sakiwit@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] boot: Enhance performance by eliminating unnecessary
 calls to printf()
References: <20110606004038.GA28970@mail.gmail.com>
In-Reply-To: <20110606004038.GA28970@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2011 05:40 PM, Jean Sacren wrote:
> Hi,
> 
> Repeated calling to printf() for 13 times is a dire waste of CPU cycles.
> For performance, combine all those calls into one while source code
> formatting is preserved for readability.
> 
> Compile tested only.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>

You're got to be bloody kidding.

First of all, this is a build time tool which is executed exactly once
during the entire kernel build.

Second, printf execution time is largely dependent on the size
formatting string; since the I/O is buffered it is only issued once
anyway... which basically means that there is no time saved at all.

Third, the resulting code is substantially harder to read.

Fourth, carrying this as a patch will cost kernel developers more time
in additional git execution time than it ever will save them in build time.

Nacked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
