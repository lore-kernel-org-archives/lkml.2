Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1BIXXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:23:05 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:42299 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab1BIXXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:23:03 -0500
Date: Wed, 9 Feb 2011 15:23:02 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
Message-ID: <20110209232302.GS11874@hexapodia.org>
References: <20110209195258.GN11874@hexapodia.org> <201102100001.42769.lasse.collin@tukaani.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102100001.42769.lasse.collin@tukaani.org>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 12:01:42AM +0200, Lasse Collin wrote:
> On 2011-02-09 Andy Isaacson wrote:
> > % make -j4
> > ...
> >   CC      arch/x86/boot/tty.o
> >   CC      arch/x86/oprofile/oprofile.mod.o
> >   XZKERN  arch/x86/boot/compressed/vmlinux.bin.xz
> > exec: 23: xz: not found
> 
> This may have something to do with the shell that "make" uses to run the 
> commands. The compression command isn't seen as failed with dash for 
> some reason.
> 
> It doesn't matter what shell is used to run xz_wrap.sh. The same problem 
> exists with other compressors if they are missing.
> 
> > commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d
> [...]
> > % ls -l arch/x86/boot/bzImage
> > -rw-r--r-- 1 adi adi 1991504 Feb  1 18:41 arch/x86/boot/bzImage
> 
> "Feb 1" was about a week ago. The file is a few days older than the 
> commit ID, assuming that your clock is set correctly.

Ah, yes, this is my regular build tree; I routinely pull and build
there.

So the build failed, but the output file remains because it failed on an
intermediate step.  (This testing was from me reproducing it on a
different system, with 100b33).

Rewinding to the original system which failed to boot...

How did "make install" create a broken
/boot/vmlinuz-2.6.38-rc3-0312-gcb5520f that caused the boot-time error
message?

If I re-run "make -j4" in the tree that caused the problem, make fails
with exit code 2.

The following seems to reproduce the silent error:

rm .config
make defconfig
make -j4
edit .config and set CONFIG_KERNEL_XZ=y, CONFIG_KERNEL_GZIP=n

% make -j4
...
Kernel: arch/x86/boot/bzImage is ready  (#64)
% echo $?
0

The resulting bzImage fails to boot with the aforementioned "Input is
not in the XZ format" error.

FWIW, the machine that's showing the problem is an Ubuntu Karmic x86_64
desktop install with all updates through mid-January installed.

-andy
