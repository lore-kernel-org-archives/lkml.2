Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab0I1UJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:09:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab0I1UJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:09:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Date: Tue, 28 Sep 2010 22:08:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linasvepstas@gmail.com,
        linux-kernel@vger.kernel.org, libc-ports@sourceware.org,
        andrew@codesourcery.com
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <201009281813.56443.arnd@arndb.de> <Pine.LNX.4.64.1009281623320.22692@digraph.polyomino.org.uk>
In-Reply-To: <Pine.LNX.4.64.1009281623320.22692@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009282208.52075.arnd@arndb.de>
X-Provags-ID: V02:K0:Yq/0BA+4nCYHSQHKeFQN7E/zkS8TxBYYxzc9PwrMZoi
 EyldT67wejtVeAJ9BDNyftrv4mY07wmAw9Yh4ngoLzvB4LNRhZ
 s+DztnB5Lf/J8M94X2oYnPNOVsbz37PlrP08ZU0pj9hFfMwLYh
 +/lE1ssOuQqCls920jnNPPEAFk0nQ1hqfLqe8PCJZLPmOl2QqE
 WGuXGS2qZCFZpaPkNV7lQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 September 2010 18:41:41 Joseph S. Myers wrote:
> In my experience very little of a glibc port relates to the particular set 
> of syscalls present on a particular architecture (and what does often 
> consists of one-line files that #include the file for i386 or some other 
> convenient architecture); changing a port from an old syscall ABI to the 
> generic one would mean making it use the new set of generic files in 
> preference to some existing sysdeps/unix/sysv/linux files, and maybe 
> having fewer bits/ headers if some of the architecture differences there 
> are avoided, but no real differences to any of the bits that aren't purely 
> mechanical such as the implementation of each architecture's TLS ABI, 
> other pieces of the ELF ABI, the set of atomic operations available, 
> startup code, longjmp, profiling, clone, the interface used to call an 
> individual syscall, etc. - remember that you can't build any vaguely 
> recent glibc without full shared library and NPTL support.
> 
> A lot of the changes made to maintain an existing port relate to 
> constants in the duplicated bits/* headers which it might be good to 
> duplicate less if future architectures share values for all the constants, 
> but that's not where most of the complexity in the port lies.  MIPS is 
> probably the worst case for code dealing with syscall ABI peculiarities 
> (given the three different ABIs, and n64 having different userspace stat 
> and stat64 structures), but even there they aren't much of a source of 
> complexity (MIPS ELF peculiarities are much more an issue).

Good point. As a kernel developer I tend to see glibc too much as
just a front-end for the system calls, but of course you are right
that it is much more that requires a lot of hard work for an architecture
port.
I did not mean to discredit the good work that has gone into the nios2
port or any part of upstream glibc.

The question that Linas was asking is specifically about the syscall
ABI and this is what I'm mostly interested in as well. A significant
part of the maintainance work in the kernel is just keeping up with
syscall ABI changes, which now gets minimized for new architectures.

	Arnd
