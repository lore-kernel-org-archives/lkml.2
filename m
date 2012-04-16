Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2DPOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:09:56 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54037 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2DPOJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:09:55 -0400
From: Paul Moore <paul@paul-moore.com>
To: libseccomp-discuss@lists.sourceforge.net
Cc: David Windsor <dwindsor@gmail.com>, linux-security-module@vger.kernel.org,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [libseccomp-discuss] ANN: libseccomp
Date: Mon, 16 Apr 2012 10:09:50 -0400
Message-ID: <30335309.9kgxB5Lv94@sifl>
User-Agent: KMail/4.8.2 (Linux/3.3.1-gentoo; KDE/4.8.2; x86_64; ; )
In-Reply-To: <CAEXv5_jiZsd6t=H1KWMNhUdgMez0B-WdC5XAHzdHffjOQh_J4A@mail.gmail.com>
References: <1540670.AFBi1SpGoi@sifl> <CAEXv5_jiZsd6t=H1KWMNhUdgMez0B-WdC5XAHzdHffjOQh_J4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 14, 2012 10:10:28 AM David Windsor wrote:
> Out of curiosity, are there any current efforts towards creating a "learning
> mode" type of application for seccomp?  I.e. creating a profile for a
> particular application based upon which syscalls it makes during normal
> operation.  I realize that many people consider this a security anti-
> pattern, but it could be useful for the initial creation of a seccomp filter
> for a particular application, and other security subsystems already do this
> (ala AppArmor's learning/complain mode).  IIUC, no other kernel mechanisms
> would need to be created; ptrace could accomplish syscall monitoring.  

I'm not aware of any serious efforts, but as Kees already pointed out, his 
seccomp tutorial could be extended to do something similar to what you 
describe.  Kees' tutorial uses raw BPF, but the same basic principles would 
work with libseccomp as well if you wanted a higher level interface.

The libseccomp sources also contain a simple little script which runs an 
application via strace and presents a slightly cleaned up version of the 
strace report which shows the syscalls, their frequency (important if you want 
to tune the seccomp filter), and some of the arguments you're likely to want 
to filter on.  Simple example:

 # ./tools/sys_inspector -h
 usage ./tools/sys_inspector [-f] [-a] [-o <file>] <command> [<args>]
 # ./tools/sys_inspector -f /bin/true
 ============================================================
 Syscall Report ("/bin/true")
    freq syscall
 ============================================================
       8 mmap
       4 mprotect
       2 open
       2 fstat
       2 close
       1 read
       1 munmap
       1 exit_group
       1 execve
       1 brk
       1 arch_prctl
       1 access

-- 
paul moore
www.paul-moore.com

