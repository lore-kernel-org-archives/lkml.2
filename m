Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab2F0ReM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:34:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39906 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758287Ab2F0ReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:34:09 -0400
Message-ID: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com>
Subject: UEFI Secure boot using qemu-kvm
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Date: Wed, 27 Jun 2012 18:34:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

The purpose of this email is to widen the pool of people who are playing
with UEFI Secure boot.  The Linux Foundation Technical Advisory Board
have been looking into this because it turns out to be rather difficult
to lay your hands on real UEFI Secure Boot enabled hardware.  Many
thanks are due to the Intel Tianocore project which recently added the
secure boot facility to their UEFI rom images.

What I have done:

I've built the tianocore boot system (along with a README describing how
to use it) and placed it in the opensuse build system so you can
download it (the OVMF package) from:

http://download.opensuse.org/repositories/home:/jejb1:/UEFI/openSUSE_12.1/

(it has no OS depends, so the rpm should be installable on almost any
distro ... including debian via alien).  Also in this repository is
Jeremy Kerr's sbsigntools which can be used to sign efi binaries.

While doing all of this, I discovered a bug in the gnu-efi environment
we usually use to build efi binaries on Linux (the fix is to the loader
script).  I've got an example of how to use the fixed script and a
builder for a LockDown.efi binary that will take a secure boot platform
in setup mode and install a Platform Key and Key Exchange Key and enable
secure boot (if you type make, it will build the PK and KEK
certificates, plus roll them into the binary).

http://git.kernel.org/?p=linux/kernel/git/jejb/efitools.git;a=summary

I'll probably add other useful efi utilities as the project progresses.

I should note that currently Jeremy's efi signing tools only really do
x86_64 binaries, so the whole project is based on that architecture.

The current state is that I've managed to lock down the secure boot
virtual platform with my own PK and KEK and verified that I can generate
signed efi binaries that will run on it (and that it will refuse to run
unsigned efi binaries).  Finally I've demonstrated that I can sign
elilo.efi (this has to be built specially because of the bug in gnu-efi)
and have it boot an unsigned linux kernel when the platform is in secure
mode (I've booted up to an initrd root prompt).

I'm releasing this now because interest in UEFI Secure Boot is rising,
particularly amongst the Linux Distributions which don't have access to
UEFI secure boot hardware, so having a virtual platform should allow
them to experiment with coming up with their own solutions.

Please remember, though, that all this is very alpha.  The Tianocore
firmware that does secure boot is only a few weeks old, and the
sbsigning tools weren't really working up until yesterday, so this is
very far from rock solid.

James

PS if you don't understand terms like Platform Key, or Setup Mode in the
above, please ask google for help.  Secure boot is very technical, but
there have been some good blog posts explaining the basics.


