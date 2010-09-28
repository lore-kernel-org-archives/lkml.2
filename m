Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0I1QOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:14:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab0I1QN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:13:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Date: Tue, 28 Sep 2010 18:13:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linasvepstas@gmail.com,
        linux-kernel@vger.kernel.org, libc-ports@sourceware.org,
        andrew@codesourcery.com
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <4CA1E809.5010103@tilera.com> <Pine.LNX.4.64.1009281537400.22692@digraph.polyomino.org.uk>
In-Reply-To: <Pine.LNX.4.64.1009281537400.22692@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281813.56443.arnd@arndb.de>
X-Provags-ID: V02:K0:eVkbXdAkueWyV0eJBSF44WVZ/8m67B5aCx77HuRPzl2
 zbS8pvM+jxaUy+hywLft4bFcMIu1kzM1/8HNN4/89ulcPYwGDX
 OeXhyHYrOq13f8d3MkRK7+/9e0NJMTND+TYobN5FwNAyqvPny1
 poXrvMVp6yspfGErYPvfsupyBpWT8atnkxof0A8qJmhNASA5II
 KVgqizXab8MB+1Jwk+7aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 September 2010, Joseph S. Myers wrote:
> (Removing libc-alpha as my comments aren't relevant to that list.)
> 
> Two of the three seem rather surprising to me as regards glibc ports being 
> ready to merge - maybe kernel ports are ready, however, it isn't clear to 
> me what (kernel or glibc) the original comment was referring to.

I was talking about kernel ports.
 
> C6X has no MMU so a glibc port isn't a possibility.  There are indeed 
> uClibc and GCC ports we will be contributing in due course - but the 
> linker support for shared objects is still in development (I contributed 
> the static linking binutils support upstream earlier this year) and is 
> required for building anything for uClinux userspace for this platform.

Right. Obviously the same question exists for uClibc though: The C6X syscall
ABI will need to be rewritten (as in deleted and replaced by generic
code) in the kernel in order to get merged, so the uClibc port will
have to gain the same kind of generic API that we need for glibc.

> As for Nios II, we have a fully functional glibc port at CodeSourcery.  
> It is I believe all our own work so there are no legal obstacles to our 
> contributing it to the FSF - but upstream contribution would not really be 
> useful without the GCC and binutils ports, and those ports (to which we 
> added PIC and TLS support among other things) are based on code from 
> Altera which is not covered by an FSF copyright assignment, so while the 
> code is available we have no current plans for Nios II upstream 
> contribution.
> 
> http://www.codesourcery.com/sgpp/portal/datasheet?target_arch=Nios+II&amp;target_os=GNU%2FLinux

Same thing here. I wouldn't call the glibc port "fully functional" because
it does not cover a mainline Linux and getting the architecture tree
upstream means replacing the syscall ABI with a proper one.

Once the kernel parts are upstream and use the generic syscall ABI, only
rudimentary architecture support in glibc would be needed.

	Arnd
