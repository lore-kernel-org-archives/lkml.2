Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0JALgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:36:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44388 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0JALgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yh/Uzo5+vQdgXoW/c5uqUeI8kuLqgSB0iJjhlYpShGM+9nM6tiX6g1maNBWlMIgoRj
         XIklI6fDqvSfyT+u49Ke5u2P9J16qN1U8yT011vhiyev+e8Ajl27MPtoO/2BBI+baYei
         dk2DuM1LcNtDTmiK8SeJlP7+KLuAyw/uEogmo=
MIME-Version: 1.0
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Date: Fri, 1 Oct 2010 07:36:35 -0400
Message-ID: <AANLkTikHcoccu-WGtSOSdkwU6Tw_An_VFkUcEoY==8=c@mail.gmail.com>
Subject: Re: Introduce support for little endian PowerPC
From: Josh Boyer <jwboyer@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 3:05 AM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> This patch set in combination with a patched GCC, binutils, uClibc and
> buildroot has allowed for a full proof of concept little endian environment on
> a 440 Taishan board, which was able to successfully run busybox, OpenSSH and a
> handful of other userspace programs without problems.

Aside from my general "uh, why?" stance, I'm very very hesitant to
integrate anything in the kernel that doesn'.t have released patches
on the toolchain side.

Also, which uClibc?  The old and crusty uClibc that uses the horrible
linuxthreads, or the somewhat less crusty that just switched to NPTL
(which hasn't been verified on normal PowerPC that I recall).  Why not
use glibc...

> This is not yet complete support for little endian PowerPC, some outstanding
> issues that I am aware of are:
>  * We only support 32bit PowerPC for now (and indeed, only 44x)
>  * The vdso has not been fixed to be endian agnostic - any userspace program
>   accessing it will get an unexpected result.
>  * I have not touched PCI at all
>  * Remaining device tree accesses still need to be examined to ensure they are
>   correctly handling the endianess of the device tree.
>  * Any other driver that uses the device tree is likely be broken for the same reason.
>  * I've included a patch for the alignment handler, however it is as yet
>   completely untested due to a property of the hardware I've been using for
>   testing.

I'm not meeting to detract here, but the Kconfig should be dependent
on && BROKEN until the above is fixed.

josh
