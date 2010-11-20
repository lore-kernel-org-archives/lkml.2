Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0KTLHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 06:07:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab0KTLHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 06:07:48 -0500
Date: Sat, 20 Nov 2010 11:05:46 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Marcus Meissner <meissner@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@osdl.org, hpa@zytor.com, mingo@elte.hu, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101120110546.GA2940@amd.home.annexia.org>
References: <20101116104600.GA24015@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116104600.GA24015@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for being late to join this thread.

I thought I'd also mention that if you can insert a small amount of
shell code into the kernel, it's trivial to search kernel memory for
the symbol table and derive anything else you want from that.

I wrote some proof of concept code to do this a few years ago[1].  I'm
pretty sure you could compress this down to a few bytes of assembler.

(Plus I don't think that removing pointers is a good idea anyway -- it
just breaks userspace tools, and any real world system is going to be
running a well-known kernel that can be downloaded from some mirror
somewhere)

Rich.

[1] It's a poor example, but in here is code that searched for ksyms
and kallsyms in 32 bit i386 kernels (files virt_mem_ksyms.ml and
virt_mem_kallsyms.ml).
http://git.annexia.org/?p=virt-mem.git;a=tree;f=lib;hb=HEAD

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
