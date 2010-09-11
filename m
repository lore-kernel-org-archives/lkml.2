Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0IKI3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:29:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:56155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0IKI3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,351,1280732400"; 
   d="scan'208";a="836781803"
Subject: Re: [PATCH] ihex: Add support for CS:IP/EIP records
From: David Woodhouse <David.Woodhouse@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
In-Reply-To: <1284039626-30394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1284039626-30394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation
Date: Sat, 11 Sep 2010 09:29:04 +0100
Message-ID: <1284193744.20200.13.camel@i7.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 14:40 +0100, Mark Brown wrote:
> ihex firmwares can include a jump address for starting execution. Add
> a -j option which will cause this to be written into the generated
> file as a record with address zero and data consisting of the address
> to jump to, allowing drivers to make use of this information.

Some questions...

- Which firmware blobs that are *already* in the kernel would need this?
  Remember, we're not adding new crap to the kernel source tree; new
  firmware images get added to linux-firmware.git instead.

- Why make the include_jump code optional? When would we ever *not* want
  to include such a record -- when does the input ihex file contain such
  a record that the kernel driver *must* not see because it can't cope
  with it?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

