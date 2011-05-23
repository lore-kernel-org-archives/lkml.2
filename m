Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1EWRjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:39:13 -0400
Received: from mail4.comsite.net ([205.238.176.238]:64817 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab1EWRjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:39:12 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Dave Carroll <dcarroll@astekcorp.com>
CC: LPPC <linuxppc-dev@lists.ozlabs.org>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: RE: [ v4] powerpc: Force page alignment for initrd reserved memory
Message-ID: <initrd-align-withdrawn@mdm.bga.com>
In-Reply-To: <522F24EF533FC546962ECFA2054FF777373072AB78@MAILSERVER2.cos.astekcorp.com>
References: <522F24EF533FC546962ECFA2054FF777373072AB75@MAILSERVER2.cos.astekcorp.com>
 <522F24EF533FC546962ECFA2054FF777373072AB78@MAILSERVER2.cos.astekcorp.com>
Date: Mon, 23 May 2011 12:39:06 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 May 2011 about 10:50:07 -0600, Dave Carroll wrote:
> I'm withdrawing this patch for the moment, due to two areas that need
> further research;
> 
> 1) An adjacent FDT blob, as mentioned by Milton Miller, and
> 

Ok ... by the way, see move_device_tree() in arch/powerpc/kernel/prom.c

> 2) Potential interaction with the crash kernel, as used in
>         init/initramfs.c

which already goes around the start and end of crashk_res, which
is adjusted to PAGE_ALIGN in reserve_crashkernel() in machine_kexec.c

 
> If anyone sees other interactions, please feel free to let me know ...
> 
> Thanks,
> -Dave Carroll

One interaction that I have ignored is preserve_initrd overlapping
crash kernel.  Loading the crash kernel destroys the preserved initrd.
But that is beyond the scope of your current patch (and probably a
seperate patch, with cross-architecture scope).

milton
