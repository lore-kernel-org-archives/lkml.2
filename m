Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0I1Qlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:41:45 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:60938 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab0I1Qlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:41:44 -0400
Date: Tue, 28 Sep 2010 16:41:41 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Arnd Bergmann <arnd@arndb.de>
cc: Chris Metcalf <cmetcalf@tilera.com>, linasvepstas@gmail.com,
        linux-kernel@vger.kernel.org, libc-ports@sourceware.org,
        andrew@codesourcery.com
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
In-Reply-To: <201009281813.56443.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1009281623320.22692@digraph.polyomino.org.uk>
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
 <4CA1E809.5010103@tilera.com> <Pine.LNX.4.64.1009281537400.22692@digraph.polyomino.org.uk>
 <201009281813.56443.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Arnd Bergmann wrote:

> Once the kernel parts are upstream and use the generic syscall ABI, only
> rudimentary architecture support in glibc would be needed.

In my experience very little of a glibc port relates to the particular set 
of syscalls present on a particular architecture (and what does often 
consists of one-line files that #include the file for i386 or some other 
convenient architecture); changing a port from an old syscall ABI to the 
generic one would mean making it use the new set of generic files in 
preference to some existing sysdeps/unix/sysv/linux files, and maybe 
having fewer bits/ headers if some of the architecture differences there 
are avoided, but no real differences to any of the bits that aren't purely 
mechanical such as the implementation of each architecture's TLS ABI, 
other pieces of the ELF ABI, the set of atomic operations available, 
startup code, longjmp, profiling, clone, the interface used to call an 
individual syscall, etc. - remember that you can't build any vaguely 
recent glibc without full shared library and NPTL support.

A lot of the *changes made to maintain an existing port* relate to 
constants in the duplicated bits/* headers which it might be good to 
duplicate less if future architectures share values for all the constants, 
but that's not where most of the complexity in the port lies.  MIPS is 
probably the worst case for code dealing with syscall ABI peculiarities 
(given the three different ABIs, and n64 having different userspace stat 
and stat64 structures), but even there they aren't much of a source of 
complexity (MIPS ELF peculiarities are much more an issue).

-- 
Joseph S. Myers
joseph@codesourcery.com
