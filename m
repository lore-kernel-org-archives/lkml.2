Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2DBKGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:06:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54930 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2DBKGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:06:38 -0400
Date: Mon, 2 Apr 2012 12:06:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: venom00 <venom00@setsun.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: pavel@users.sourceforge.net, rjwysocki@users.sourceforge.net
Subject: Re: [s2disk] Inappropriate ioctl on /dev/snapshot
Message-ID: <20120402100625.GA1216@elf.ucw.cz>
References: <EV0ByeH8JeDWvk23_hS3M1XIjq7ZqojHm-IJJdI6CcZXMuZdq2gOAlqCGWMX1UCTpf9qG5vgeUMtaBztXYzLkQ@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <EV0ByeH8JeDWvk23_hS3M1XIjq7ZqojHm-IJJdI6CcZXMuZdq2gOAlqCGWMX1UCTpf9qG5vgeUMtaBztXYzLkQ@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2012-04-01 00:10:58, venom00 wrote:
> Hello, I've just switched to Linux 3.3.0 and s2disk is not working. 
> The error message says:
> 
> s2disk: check_free_swap failed. Reason: Inappropriate ioctl for device
> s2disk: No swap space for suspend
> 
> Take a look at the attached strace log file.

Hi! If it worked on previous kernels, it is an  regression and
something for rjw to track.

By chance, are you using 32bit userland on 64bit kernel?

(Rafael: Did we remove some compatibility code, recently?)

Thanks for report,
								Pavel

> open("/dev/snapshot", O_RDONLY)         = 4
> ioctl(4, SNAPSHOT_SET_SWAP_AREA, 0x7fff8113f9a0) = 0
> ioctl(4, 0x80083307, 0x7fff31183760)    = -1 ENOTTY (Inappropriate ioctl for device)
> write(2, "s2disk: check_free_swap failed. Reason: Inappropriate ioctl for device\n", 71) = 71
> write(2, "s2disk: No swap space for suspend\n", 34) = 34
> close(4)                                = 0
> 
> Should I move this discussion to the Linux Bug Tracker?
> 
> Thank in advance!

> execve("/usr/sbin/s2disk", ["s2disk"], [/* 20 vars */]) = 0
> brk(0)                                  = 0x23a3000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6df2c000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> open("/etc/ld.so.cache", O_RDONLY)      = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=259913, ...}) = 0
> mmap(NULL, 259913, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fce6deec000
> close(3)                                = 0
> open("/usr/lib64/liblzo2.so.2", O_RDONLY) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360+\0\0\0\0\0\0@\0\0\0\0\0\0\0\210\21\2\0\0\0\0\0\0\0\0\0@\0008\0\7\0@\0\32\0\31\0\1\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\344\5\2\0\0\0\0\0\344\5\2\0\0\0\0\0\0\0 \0\0\0\0\0\1\0\0\0\6\0\0\0\260\f\2\0\0\0\0\0\260\f\"\0\0\0\0\0\260\f\"\0\0\0\0\0\10\4\0\0\0\0\0\0\30\4\0\0\0\0\0\0\0\0 \0\0\0\0\0\2\0\0\0\6\0\0\0(\16\2\0\0\0\0\0(\16\"\0\0\0\0\0(\16\"\0\0\0\0\0\240\1\0\0\0\0\0\0\240\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0P\345td\4\0\0\0\330\343\1\0\0\0\0\0\330\343\1\0\0\0\0\0\330\343\1\0\0\0\0\0\304\4\0\0\0\0\0\0\304\4\0\0\0\0\0\0\4\0\0\0\0\0\0\0Q\345td\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0R\345td\4\0\0\0\260\f\2\0\0\0\0\0\260\f\"\0\0\0\0\0\260\f\"\0\0\0\0\0P\3\0\0\0\0\0\0P\3\0\0\0\0\0\0\1\0\0\0\0\0\0\0\200\25\4e\0(\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0\365\0\0\0\203\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0g\0\0\0y\0\0\0\36\0\0\0\0\0\0\0\3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0x\0\0\0\0\0\0\0%\0\0\0\0\0\0\0+\0\0\0~\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0^\0\0\0\0\0\0\0\0\0\0\0p\0\0\0\0\0\0\0\31\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\16\0\0\0\0\0\0\0u\0\0\0J\0\0\0M\0\0\0*\0\0\0000\0\0\0\0\0\0\0\32\0\0\0\0\0\0\0o\0\0\0[\0\0\0\0\0\0\0$\0\0\0\0\0\0\0j\0\0\0T\0\0\0A\0\0\0\0\0\0\0\0\0\0\0 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\35\0\0\0<\0\0\0!\0\0\0\0\0\0\0\0\0\0\0C\0\0\0{\0\0\0\4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0N\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0b\0\0\0B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\23\0\0\0d\0\0\0c\0\0\0005\0\0\0", 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=137224, ...}) = 0
> mmap(NULL, 2232520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fce6daec000
> mprotect(0x7fce6db0d000, 2093056, PROT_NONE) = 0
> mmap(0x7fce6dd0c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fce6dd0c000
> close(3)                                = 0
> open("/usr/lib64/libgcrypt.so.11", O_RDONLY) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\212\0\0\0\0\0\0@\0\0\0\0\0\0\0 \247\7\0\0\0\0\0\0\0\0\0@\0008\0\7\0@\0\33\0\32\0\1\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\344e\7\0\0\0\0\0\344e\7\0\0\0\0\0\0\0 \0\0\0\0\0\1\0\0\0\6\0\0\0\0t\7\0\0\0\0\0\0t'\0\0\0\0\0\0t'\0\0\0\0\0D2\0\0\0\0\0\0x7\0\0\0\0\0\0\0\0 \0\0\0\0\0\2\0\0\0\6\0\0\0\240}\7\0\0\0\0\0\240}'\0\0\0\0\0\240}'\0\0\0\0\0\320\1\0\0\0\0\0\0\320\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0P\345td\4\0\0\0\240\273\6\0\0\0\0\0\240\273\6\0\0\0\0\0\240\273\6\0\0\0\0\0\214\34\0\0\0\0\0\0\214\34\0\0\0\0\0\0\4\0\0\0\0\0\0\0Q\345td\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0R\345td\4\0\0\0\0t\7\0\0\0\0\0\0t'\0\0\0\0\0\0t'\0\0\0\0\0\0\f\0\0\0\0\0\0\0\f\0\0\0\0\0\0\1\0\0\0\0\0\0\0\200\25\4e\0(\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0\22\2\0\0\17\1\0\0\0\0\0\0\0\0\0\0r\0\0\0\10\0\0\0\264\0\0\0\0\0\0\0\35\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\270\0\0\0\0\0\0\0\0\0\0\0\301\0\0\0\1\1\0\0a\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\266\0\0\0\0\0\0\0\0\0\0\0\225\0\0\0\0\0\0\0\277\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\241\0\0\0001\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0002\0\0\0\0\0\0\0\315\0\0\0\235\0\0\0\352\0\0\0\0\0\0\0}\0\0\0\0\0\0\0\234\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0y\0\0\0\0\0\0\0\0\0\0\0\324\0\0\0F\0\0\0\207\0\0\0\0\0\0\0\0\0\0\0\317\0\0\0\302\0\0\0\252\0\0\0-\0\0\0\0\0\0\0\0\0\0\0\332\0\0\0\0\0\0\0\0\0\0\0\201\0\0\0\247\0\0\0\0\0\0\0\310\0\0\0006\0\0\0\0\0\0\0\262\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\314\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=503264, ...}) = 0
> mmap(NULL, 2599800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fce6d871000
> mprotect(0x7fce6d8e8000, 2097152, PROT_NONE) = 0
> mmap(0x7fce6dae8000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x77000) = 0x7fce6dae8000
> close(3)                                = 0
> open("/lib64/libc.so.6", O_RDONLY)      = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260!\2\0\0\0\0\0@\0\0\0\0\0\0\0\220{\30\0\0\0\0\0\0\0\0\0@\0008\0\v\0@\0E\0D\0\6\0\0\0\5\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0h\2\0\0\0\0\0\0h\2\0\0\0\0\0\0\10\0\0\0\0\0\0\0\3\0\0\0\4\0\0\0\220N\25\0\0\0\0\0\220N\25\0\0\0\0\0\220N\25\0\0\0\0\0\34\0\0\0\0\0\0\0\34\0\0\0\0\0\0\0\20\0\0\0\0\0\0\0\1\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0X\31\30\0\0\0\0\0X\31\30\0\0\0\0\0\0\0 \0\0\0\0\0\1\0\0\0\6\0\0\0\30'\30\0\0\0\0\0\30'8\0\0\0\0\0\30'8\0\0\0\0\0\240F\0\0\0\0\0\0\360\224\0\0\0\0\0\0\0\0 \0\0\0\0\0\2\0\0\0\6\0\0\0@[\30\0\0\0\0\0@[8\0\0\0\0\0@[8\0\0\0\0\0\360\1\0\0\0\0\0\0\360\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0\4\0\0\0\4\0\0\0\250\2\0\0\0\0\0\0\250\2\0\0\0\0\0\0\250\2\0\0\0\0\0\0 \0\0\0\0\0\0\0 \0\0\0\0\0\0\0\4\0\0\0\0\0\0\0\7\0\0\0\4\0\0\0\30'\30\0\0\0\0\0\30'8\0\0\0\0\0\30'8\0\0\0\0\0\20\0\0\0\0\0\0\0h\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0P\345td\4\0\0\0\254N\25\0\0\0\0\0\254N\25\0\0\0\0\0\254N\25\0\0\0\0\0\214h\0\0\0\0\0\0\214h\0\0\0\0\0\0\4\0\0\0\0\0\0\0Q\345td\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0R\345td\4\0\0\0\30'\30\0\0\0\0\0\30'8\0\0\0\0\0\30'8\0\0\0\0\0\3508\0\0\0\0\0\0\3508\0\0\0\0\0\0\1\0\0\0\0\0\0\0\200\25\4e\0(\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0\4\0\0\0\20\0\0\0\1\0\0\0GNU\0\0\0\0\0\2\0\0\0\6\0\0\0\t\0\0\0\371\3\0\0|\10\0\0\17\6\0\0\235\3\0\0C\10\0\0'\6\0\0m\5\0\0~\6\0\0\0\0\0\0\254\0\0\0\"\6\0\0005\6\0\0\236\5\0\0|\1\0\0\21\1\0\0F\4\0\0\263\0\0\0\247\6\0\0\306\1\0\0\252\3\0\0008\7\0\0\314\6\0\0\333\7\0\0\24\5\0\0\0\0\0\0\306\2\0\0\23\7\0\0\0\0\0\0;\7\0\0\235\5\0\0", 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=1608912, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6deeb000
> mmap(NULL, 3718152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fce6d4e5000
> mprotect(0x7fce6d667000, 2097152, PROT_NONE) = 0
> mmap(0x7fce6d867000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x182000) = 0x7fce6d867000
> mmap(0x7fce6d86c000, 19464, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fce6d86c000
> close(3)                                = 0
> open("/usr/lib64/libgpg-error.so.0", O_RDONLY) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\t\0\0\0\0\0\0@\0\0\0\0\0\0\0\0201\0\0\0\0\0\0\0\0\0\0@\0008\0\7\0@\0\31\0\30\0\1\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\264,\0\0\0\0\0\0\264,\0\0\0\0\0\0\0\0 \0\0\0\0\0\1\0\0\0\6\0\0\0\0.\0\0\0\0\0\0\0. \0\0\0\0\0\0. \0\0\0\0\0P\2\0\0\0\0\0\0`\2\0\0\0\0\0\0\0\0 \0\0\0\0\0\2\0\0\0\6\0\0\0000.\0\0\0\0\0\0000. \0\0\0\0\0000. \0\0\0\0\0\240\1\0\0\0\0\0\0\240\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0P\345td\4\0\0\0008+\0\0\0\0\0\0008+\0\0\0\0\0\0008+\0\0\0\0\0\0T\0\0\0\0\0\0\0T\0\0\0\0\0\0\0\4\0\0\0\0\0\0\0Q\345td\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0R\345td\4\0\0\0\0.\0\0\0\0\0\0\0. \0\0\0\0\0\0. \0\0\0\0\0\0\2\0\0\0\0\0\0\0\2\0\0\0\0\0\0\1\0\0\0\0\0\0\0\200\25\4e\0(\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\0\0\0\0\0\0\37\0\0\0\32\0\0\0\17\0\0\0\20\0\0\0\0\0\0\0\24\0\0\0\v\0\0\0\0\0\0\0\22\0\0\0\4\0\0\0\10\0\0\0\0\0\0\0\23\0\0\0\t\0\0\0\7\0\0\0\n\0\0\0\6\0\0\0\21\0\0\0\f\0\0\0\16\0\0\0\26\0\0\0\0\0\0\0\3\0\0\0\0\0\0\0\30\0\0\0\0\0\0\0\31\0\0\0\2\0\0\0\0\0\0\0\25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\27\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\31\0\0\0\f\0\0\0\2\0\0\0\7\0\0\0\241 @h#\0\22\t\210\4\0\3\250\24\0\0\f\0\0\0\r\0\0\0\0\0\0\0\16\0\0\0\0\0\0\0\17\0\0\0\0\0\0\0\0\0\0\0\20\0\0\0\0\0\0\0\21\0\0\0\0\0\0\0\0\0\0\0\22\0\0\0\23\0\0\0\24\0\0\0\0\0\0\0\25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\26\0\0\0\0\0\0\0\30\0\0\0\0\0\0\0CE\325\354", 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=14160, ...}) = 0
> mmap(NULL, 2109536, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fce6d2e1000
> mprotect(0x7fce6d2e4000, 2093056, PROT_NONE) = 0
> mmap(0x7fce6d4e3000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7fce6d4e3000
> close(3)                                = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6deea000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6dee9000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6dee8000
> arch_prctl(ARCH_SET_FS, 0x7fce6dee9700) = 0
> mprotect(0x7fce6d4e3000, 4096, PROT_READ) = 0
> mprotect(0x7fce6d867000, 16384, PROT_READ) = 0
> mprotect(0x7fce6dae8000, 4096, PROT_READ) = 0
> mprotect(0x7fce6dd0c000, 4096, PROT_READ) = 0
> mprotect(0x608000, 4096, PROT_READ)     = 0
> mprotect(0x7fce6df2d000, 4096, PROT_READ) = 0
> munmap(0x7fce6deec000, 259913)          = 0
> brk(0)                                  = 0x23a3000
> brk(0x23c4000)                          = 0x23c4000
> open("/dev/null", O_RDWR)               = 3
> close(3)                                = 0
> stat("/etc/suspend.conf", {st_mode=S_IFREG|0644, st_size=192, ...}) = 0
> open("/etc/suspend.conf", O_RDONLY)     = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=192, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6df2b000
> read(3, "snapshot device = /dev/snapshot\nresume device = /dev/gaia/overflow\n#image size = 350000000\n#suspend loglevel = 2\ncompute checksum = y\ncompress = y\n#encrypt = y\n#early writeout = y\n#splash = y\n", 4096) = 192
> read(3, "", 4096)                       = 0
> close(3)                                = 0
> munmap(0x7fce6df2b000, 4096)            = 0
> mmap(NULL, 278528, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6dea4000
> mlockall(MCL_CURRENT|MCL_FUTURE)        = 0
> getpid()                                = 15500
> mount("none", "/proc/15500", "tmpfs", 0, NULL) = 0
> stat("/dev/gaia/overflow", {st_mode=S_IFBLK|0600, st_rdev=makedev(253, 2), ...}) = 0
> chdir("/proc/15500")                    = 0
> mknod("resume", S_IFBLK|0600, makedev(253, 2)) = 0
> open("resume", O_RDWR)                  = 3
> stat("/dev/snapshot", {st_mode=S_IFCHR|0600, st_rdev=makedev(10, 231), ...}) = 0
> open("/dev/snapshot", O_RDONLY)         = 4
> ioctl(4, SNAPSHOT_SET_SWAP_AREA, 0x7fff311839c0) = 0
> open("/dev/console", O_RDONLY)          = 5
> ioctl(5, KDGKBTYPE, 0x7fff31183a1c)     = 0
> ioctl(5, TIOCLINUX, 0x7fff311839d0)     = 0
> ioctl(5, VT_GETSTATE, 0x7fff31183a10)   = 0
> ioctl(5, VIDIOC_QUERYCAP or VT_OPENQRY, 0x7fff31183a18) = 0
> close(5)                                = 0
> open("/dev/tty8", O_RDWR)               = 5
> ioctl(5, VT_ACTIVATE, 0x8)              = 0
> ioctl(5, VT_WAITACTIVE, 0x8)            = 0
> write(5, "\33[H\33[J", 6)               = 6
> dup2(5, 0)                              = 0
> dup2(5, 1)                              = 1
> dup2(5, 2)                              = 2
> ioctl(5, TIOCLINUX, 0x7fff311839d0)     = 0
> open("/dev/console", O_RDONLY)          = 6
> ioctl(6, KDGKBTYPE, 0x7fff31183a1c)     = 0
> ioctl(6, VT_GETSTATE, 0x7fff31183a10)   = 0
> close(6)                                = 0
> open("/dev/tty8", O_RDWR)               = 6
> ioctl(6, VIDIOC_RESERVED or VT_GETMODE, 0x7fff311839d0) = 0
> rt_sigaction(SIGUSR1, {SIG_IGN, [], SA_RESTORER|SA_RESTART, 0x7fce6d51ab80}, NULL, 8) = 0
> ioctl(6, VIDIOC_ENUM_FMT or VT_SETMODE, 0x7fff311839d0) = 0
> stat("/proc/sys/kernel/printk", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> open("/proc/sys/kernel/printk", O_RDWR) = 7
> fstat(7, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6df2b000
> lseek(7, 0, SEEK_SET)                   = 0
> read(7, "1\t4\t1\t7\n", 1024)           = 8
> lseek(7, 8, SEEK_SET)                   = 8
> lseek(7, -8, SEEK_CUR)                  = 0
> write(7, "1\n", 2)                      = 2
> open("/proc/sys/vm/swappiness", O_RDWR) = 8
> fstat(8, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fce6df2a000
> lseek(8, 0, SEEK_SET)                   = 0
> read(8, "60\n", 1024)                   = 3
> lseek(8, 3, SEEK_SET)                   = 3
> lseek(8, -3, SEEK_CUR)                  = 0
> write(8, "100\n", 4)                    = 4
> sync()                                  = 0
> setrlimit(RLIMIT_NOFILE, {rlim_cur=0, rlim_max=0}) = 0
> setrlimit(RLIMIT_NPROC, {rlim_cur=0, rlim_max=0}) = 0
> setrlimit(RLIMIT_CORE, {rlim_cur=0, rlim_max=0}) = 0
> ioctl(4, 0x80083307, 0x7fff31183760)    = -1 ENOTTY (Inappropriate ioctl for device)
> write(2, "s2disk: check_free_swap failed. Reason: Inappropriate ioctl for device\n", 71) = 71
> write(2, "s2disk: No swap space for suspend\n", 34) = 34
> lseek(7, 0, SEEK_SET)                   = 0
> write(7, "1\n", 2)                      = 2
> close(7)                                = 0
> munmap(0x7fce6df2b000, 4096)            = 0
> lseek(8, 0, SEEK_SET)                   = 0
> write(8, "60\n", 3)                     = 3
> close(8)                                = 0
> munmap(0x7fce6df2a000, 4096)            = 0
> ioctl(6, VIDIOC_ENUM_FMT or VT_SETMODE, 0x609ba8) = 0
> close(6)                                = 0
> ioctl(5, VT_ACTIVATE, 0x7)              = 0
> ioctl(5, VT_WAITACTIVE, 0x7)            = 0
> ioctl(5, TIOCLINUX, 0x7fff311839d0)     = 0
> close(5)                                = 0
> close(4)                                = 0
> close(3)                                = 0
> chdir("/")                              = 0
> umount("/proc/15500", 0)                = 0
> munmap(0x7fce6dea4000, 278528)          = 0
> exit_group(28)                          = ?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
