Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0D1UWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:22:21 -0400
Received: from www.tglx.de ([62.245.132.106]:58107 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0D1UWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:22:20 -0400
Date: Wed, 28 Apr 2010 22:22:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
In-Reply-To: <g2we6bf505b1004281306sa6ddb207p7a1b8853c3ab308f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004282218470.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>  <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>  <1272399798.2255.2.camel@localhost>  <1272400246.2255.5.camel@localhost>  <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
  <1272434481.1974.101.camel@work-vm>  <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>  <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain>  <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com> 
 <alpine.LFD.2.00.1004282137330.2951@localhost.localdomain> <g2we6bf505b1004281306sa6ddb207p7a1b8853c3ab308f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1070554541-1272486132=:2951"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1070554541-1272486132=:2951
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 28 Apr 2010, Xianghua Xiao wrote:
> On Wed, Apr 28, 2010 at 2:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 28 Apr 2010, Xianghua Xiao wrote:
> >> Thomas,
> >> I patched it and re-run it however did not find any condition from
> >> your patch had a hit.
> >> In your patch I changed :
> >>
> >> if (!file->f_path) {
> >> to
> >> if(!(&(file->f_path))){
> >> Otherwise it won't compile as f_path is a not a pointer.
> >
> > True :)
> >
> >> # reboot
> >> # Oops: Kernel access of bad area, sig: 11 [#1]
> >
> > Ok. Can you please enable CONFIG_DEBUG_LIST ?
> >
> > Thanks,
> >
> >        tglx
> >
> I turned on that, could not find any difference from the oops log.
> If I try to remount it rw then ro, the remount ro will cause similar oops
> Thanks,
> Xianghua
> 
> # reboot
> # Oops: Kernel access of bad area, sig: 11 [#1]
> PREEMPT 834x SYS
> Modules linked in:
> NIP: c009ca1c LR: c009c9cc CTR: 00000000

Can you please decode the code lines with 

# addr2line -e vmlinux 0xc009ca1c 0xc009c9cc

You need to enable CONFIG_DEBUG_INFO to get real line numbers.

Thanks,

	tglx
--8323328-1070554541-1272486132=:2951--
