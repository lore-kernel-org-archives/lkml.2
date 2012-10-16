Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2JPH7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:59:08 -0400
Received: from tee.schottelius.org ([77.109.138.222]:34614 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753532Ab2JPH7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:59:07 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 03:59:07 EDT
Date: Tue, 16 Oct 2012 09:51:22 +0200
From: Nico Schottelius <nico-kernel20121016@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Very bad performance on Qemu/KVM
Message-ID: <20121016075122.GA25824@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20121016@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.6-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning LKML,

I see extremely slow virtual machines
running on qemu-kvm-0.12.1.2-2.295.el6_3.2.x86_64
on Centos 6.3 with Linux 2.6.32-279.5.2.el6.x86_64 on a
64 core machine using AMD Opteron(TM) Processor 6276 (dell r815).

The guests are Centos 6.3, Linux 2.6.32-220.13.1.el6.x86_64.
The disk images reside on local storage, ext4 filesystem.

I checked that kvm is loaded and enabled. I changed
-drive to use if=virtio, -net to use model=virtio.

>From the processes running it seems that cpu performance is the
bottleneck. I added -cpu host to skip the emulation, but this did
not fix the issue.

Comparing the performance to qemu running on a xenserver, performance is
at most half of it.


Does anyone of you have a good pointer how to debug this further or are
there any known issues with the given setup? 

I'm happy for every pointer I get, as there seems to be no easy to spot
issue.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
