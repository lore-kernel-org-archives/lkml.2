Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1HSLIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:08:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35050 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1HSLI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:08:28 -0400
Subject: Re: [kernel.org users] [KORG] Taking hera down to deal with the
 load issues
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: warthog9@kernel.org, linux-kernel@vger.kernel.org, users@kernel.org
In-Reply-To: <20110818.221433.2023110799070604982.davem@davemloft.net>
References: <4E4AFCFC.9020008@kernel.org>	<4E4B7664.9070301@kernel.org>
	 <20110818.221433.2023110799070604982.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 07:08:23 -0400
Message-ID: <1313752103.3243.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 22:14 -0700, David Miller wrote:
> From: "J.H." <warthog9@kernel.org>
> Date: Wed, 17 Aug 2011 01:05:56 -0700
> 
> > This second kernel is at least, so far, acting a lot closer to what I'd
> > expect from hera, but the disk cache is still filling.  I'm going to
> > keep an eye on it for a bit longer tonight.  As a note, the only
> > difference between the first 3.1-rc1 kernel and the second, that is
> > currently running, was the explicit disabling of IMA and recompiling the
> > kernel.
> 
> I wonder if the IMA bits are generating crypto hashes for every file
> modification done on the machine.

Possibly, but IMA doesn't recalculate the hash for every modification.
Without the boot command line parameter 'ima_tcb', nothing should be
measured.  With 'ima_tcb', only files accessed by root are measured and
then only re-measured, if flushed from the inode cache or has been
marked changed, which occurs on __fput(), not every write.

thanks,

Mimi

