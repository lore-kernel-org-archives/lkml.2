Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1EEDDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 23:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab1EEDDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 23:03:15 -0400
Date: Wed, 4 May 2011 23:02:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, kexec@lists.infradead.org,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] Kdump and memory error handling
Message-ID: <20110505030256.GA11823@redhat.com>
References: <20110504193509.GA5342@in.ibm.com>
 <20110504203914.GC1737@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504203914.GC1737@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 10:39:14PM +0200, Andi Kleen wrote:
> > Any thoughts/suggestions?
> 
> My old attempts to solve this are
> 
> Don't dump on MCE:
> 
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/xpanic
> 
> Handle dumps of corrupted memory regresions:
> 
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/crashdump
> 

This idea of disabling mce temporarily sounds interesting. 

The slim dump giving access to log buffers makes most sense to me. Why
not leave it to user space to filter out only log buffers. So if a 
crash happens due to MCE, we can probably append an ELF note section
to vmcore and may be user space filtering utitliy (makedumpfile) can
extract and save only log portion of dump if it is an MCE triggered crash.

Of course this needs to be coupled with Andi's patch of disabling mce
temporarily so that makedumpfile does not induce another crash.

On a side note, can we just save log buf in NVRAM area and access later
using pstore (by tony luck) and if we can detect that system has that
NVRAM capability then skip kdump or something like that.

Thanks
Vivek
