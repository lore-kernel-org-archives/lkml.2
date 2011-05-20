Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185Ab1ETHhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:37:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57542 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932097Ab1ETHhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:37:22 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+Sr9B3Gi+SM30SWNl2SOkdaekHjp09emkpXxORe4
	CUcxl2heW5qLKB
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Fri, 20 May 2011 09:37:13 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
Cc: "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
References: <201105191526.31904.toralf.foerster@gmx.de> <201105192218.18261.toralf.foerster@gmx.de> <20110519204342.GA10792@home.goodmis.org>
In-Reply-To: <20110519204342.GA10792@home.goodmis.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105200937.15322.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven Rostedt wrote at 22:43:43
> Is this bug fully reproducable? If not, then you may have had a git
> bisect good, when it should have been git bisect bad.
Yes, bisected it again to the same commit.
Furthermore I explicitely checked out that revision - tested it - issue exists,
reverted exactly that commit on top of the checked out tree and tested it
again, issue went away.
Then I recompiled the buggy version with CONFIG_DEBUG_INFO=y
here's the output :

...
Kernel panic - not syncing: Kernel mode fault at addr 0x0, ip 0x80a9f6b
08324b44:  [<0829e78b>] dump_stack+0x22/0x24
08324b5c:  [<0829e7f0>] panic+0x63/0x167
08324b84:  [<080603d2>] segv+0x1e2/0x2b0
08324c3c:  [<080604e1>] segv_handler+0x41/0x60
08324c5c:  [<08070c54>] sig_handler_common+0x44/0xb0
08324cd8:  [<08070e32>] sig_handler+0x42/0x50
08324ce8:  [<0807106c>] handle_signal+0x5c/0xa0
08324d0c:  [<08073408>] hard_handler+0x18/0x20
08324d1c:  [<b7715400>] 0xb7715400


EIP: 0073:[<400008d2>] CPU: 0 Tainted: G        W   ESP: 007b:4ef22270 EFLAGS: 00200206
    Tainted: G        W  
EAX: ffffffda EBX: 081efe10 ECX: 00000081 EDX: 00000001
ESI: 083f6758 EDI: 081efe0c EBP: 080a88a8 DS: 007b ES: 007b
08324af8:  [<080780bd>] show_regs+0xed/0x120
08324b14:  [<0806071c>] panic_exit+0x2c/0x50
08324b24:  [<0809fc1c>] notifier_call_chain+0x4c/0x70
08324b4c:  [<0809fc93>] atomic_notifier_call_chain+0x23/0x30
08324b5c:  [<0829e818>] panic+0x8b/0x167
08324b84:  [<080603d2>] segv+0x1e2/0x2b0
08324c3c:  [<080604e1>] segv_handler+0x41/0x60
08324c5c:  [<08070c54>] sig_handler_common+0x44/0xb0
08324cd8:  [<08070e32>] sig_handler+0x42/0x50
08324ce8:  [<0807106c>] handle_signal+0x5c/0xa0
08324d0c:  [<08073408>] hard_handler+0x18/0x20
08324d1c:  [<b7715400>] 0xb7715400


The file /var/log/messages of the UML says :

2011-05-20T09:33:03.455+02:00 n22_uml kernel: ------------[ cut here ]------------                                                                                                                       
2011-05-20T09:33:03.455+02:00 n22_uml kernel: WARNING: at kernel/futex.c:789 wake_futex+0x28/0x60()                                                                                                      
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5bd14:  [<0829e78b>] dump_stack+0x22/0x24
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5bd2c:  [<0808205a>] warn_slowpath_common+0x5a/0x80                                                                                                                                             
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5bd54:  [<080820a3>] warn_slowpath_null+0x23/0x30                                                                                                                                               
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5bd64:  [<080a9eb8>] wake_futex+0x28/0x60                                                                                                                                                       
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5bd7c:  [<080a9faf>] futex_wake+0xbf/0x100                                                                                                                                                      
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5bda4:  [<080abb1d>] do_futex+0xcd/0x6c0                                                                                                                                                        
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5be08:  [<080ac184>] sys_futex+0x74/0x140                                                                                                                                                       
2011-05-20T09:33:03.455+02:00 n22_uml kernel: 19e5be60:  [<0807ffc1>] mm_release+0xd1/0x130                                                                                                                                                      
2011-05-20T09:33:03.457+02:00 n22_uml kernel: 19e5be8c:  [<08083dad>] exit_mm+0x1d/0x100                                                                                                                                                         
2011-05-20T09:33:03.457+02:00 n22_uml kernel: 19e5beb8:  [<08085b73>] do_exit+0xc3/0x660                                                                                                                                                         
2011-05-20T09:33:03.457+02:00 n22_uml kernel: 19e5bf14:  [<080861e9>] sys_exit+0x19/0x20                                                                                                                                                         
2011-05-20T09:33:03.457+02:00 n22_uml kernel: 19e5bf20:  [<08060d16>] handle_syscall+0xa6/0xb0                                                                                                                                                   
2011-05-20T09:33:03.457+02:00 n22_uml kernel: 19e5bf68:  [<08074cf1>] userspace+0x361/0x500                                                                                                                                                      
2011-05-20T09:33:03.457+02:00 n22_uml kernel: 19e5bfe8:  [<0805e0cb>] fork_handler+0x5b/0x70                                                                                                                                                     
2011-05-20T09:33:03.457+02:00 n22_uml kernel: 19e5bffc:  [<00000000>] 0x0                                                                                                                                                                        
2011-05-20T09:33:03.457+02:00 n22_uml kernel:                                                                                                                                                                                                    
2011-05-20T09:33:03.457+02:00 n22_uml kernel: ---[ end trace 95fb08f635a473e8 ]---
2011-05-20T09:33:03.831+02:00 n22_uml kernel: ------------[ cut here ]------------
2011-05-20T09:33:03.831+02:00 n22_uml kernel: WARNING: at kernel/futex.c:789 wake_futex+0x28/0x60()
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99d14:  [<0829e78b>] dump_stack+0x22/0x24
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99d2c:  [<0808205a>] warn_slowpath_common+0x5a/0x80
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99d54:  [<080820a3>] warn_slowpath_null+0x23/0x30
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99d64:  [<080a9eb8>] wake_futex+0x28/0x60
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99d7c:  [<080a9faf>] futex_wake+0xbf/0x100
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99da4:  [<080abb1d>] do_futex+0xcd/0x6c0
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99e08:  [<080ac184>] sys_futex+0x74/0x140
2011-05-20T09:33:03.831+02:00 n22_uml kernel: 19d99e60:  [<0807ffc1>] mm_release+0xd1/0x130
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 19d99e8c:  [<08083dad>] exit_mm+0x1d/0x100
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 19d99eb8:  [<08085b73>] do_exit+0xc3/0x660
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 19d99f14:  [<080861e9>] sys_exit+0x19/0x20
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 19d99f20:  [<08060d16>] handle_syscall+0xa6/0xb0
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 19d99f68:  [<08074cf1>] userspace+0x361/0x500
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 19d99fe8:  [<0805e0cb>] fork_handler+0x5b/0x70
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 19d99ffc:  [<00000000>] 0x0
2011-05-20T09:33:03.832+02:00 n22_uml kernel: 
2011-05-20T09:33:03.832+02:00 n22_uml kernel: ---[ end trace 95fb08f635a473e9 ]---
2011-05-20T09:33:03.951+02:00 n22_uml kernel: ------------[ cut here ]------------
2011-05-20T09:33:03.951+02:00 n22_uml kernel: WARNING: at kernel/futex.c:789 wake_futex+0x28/0x60()
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5bd78:  [<0829e78b>] dump_stack+0x22/0x24
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5bd90:  [<0808205a>] warn_slowpath_common+0x5a/0x80
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5bdb8:  [<080820a3>] warn_slowpath_null+0x23/0x30
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5bdc8:  [<080a9eb8>] wake_futex+0x28/0x60
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5bde0:  [<080ab702>] futex_requeue+0x362/0x6b0
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5be64:  [<080abceb>] do_futex+0x29b/0x6c0
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5bec8:  [<080ac184>] sys_futex+0x74/0x140
2011-05-20T09:33:03.951+02:00 n22_uml kernel: 19e5bf20:  [<08060d16>] handle_syscall+0xa6/0xb0
2011-05-20T09:33:03.955+02:00 n22_uml kernel: 19e5bf68:  [<08074cf1>] userspace+0x361/0x500
2011-05-20T09:33:03.955+02:00 n22_uml kernel: 19e5bfe8:  [<0805e0cb>] fork_handler+0x5b/0x70
2011-05-20T09:33:03.955+02:00 n22_uml kernel: 19e5bffc:  [<00000000>] 0x0
2011-05-20T09:33:03.955+02:00 n22_uml kernel: 
2011-05-20T09:33:03.955+02:00 n22_uml kernel: ---[ end trace 95fb08f635a473ea ]---
2011-05-20T09:33:04.000+02:00 n22_uml sshd[738]: Server listening on 0.0.0.0 port 22.
2011-05-20T09:33:06.100+02:00 n22_uml kernel: ------------[ cut here ]------------
2011-05-20T09:33:06.100+02:00 n22_uml kernel: WARNING: at kernel/futex.c:789 wake_futex+0x28/0x60()
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0d14:  [<0829e78b>] dump_stack+0x22/0x24
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0d2c:  [<0808205a>] warn_slowpath_common+0x5a/0x80
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0d54:  [<080820a3>] warn_slowpath_null+0x23/0x30
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0d64:  [<080a9eb8>] wake_futex+0x28/0x60
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0d7c:  [<080a9faf>] futex_wake+0xbf/0x100
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0da4:  [<080abb1d>] do_futex+0xcd/0x6c0
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0e08:  [<080ac184>] sys_futex+0x74/0x140
2011-05-20T09:33:06.100+02:00 n22_uml kernel: 19ef0e60:  [<0807ffc1>] mm_release+0xd1/0x130
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 19ef0e8c:  [<08083dad>] exit_mm+0x1d/0x100
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 19ef0eb8:  [<08085b73>] do_exit+0xc3/0x660
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 19ef0f14:  [<080861e9>] sys_exit+0x19/0x20
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 19ef0f20:  [<08060d16>] handle_syscall+0xa6/0xb0
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 19ef0f68:  [<08074cf1>] userspace+0x361/0x500
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 19ef0fe8:  [<0805e0cb>] fork_handler+0x5b/0x70
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 19ef0ffc:  [<00000000>] 0x0
2011-05-20T09:33:06.104+02:00 n22_uml kernel: 
2011-05-20T09:33:06.104+02:00 n22_uml kernel: ---[ end trace 95fb08f635a473eb ]---
2011-05-20T09:33:09.000+02:00 n22_uml cron[851]: (CRON) STARTUP (V5.0)
2011-05-20T09:33:10.112+02:00 n22_uml kernel: Virtual console 1 assigned device '/dev/pts/5'


> 
> The futex/plist should not be affecting rwsem.
> 
> -- Steve
> 
> > tfoerste@n22 ~/devel/linux-2.6 $ git bisect bad
> > 2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c is the first bad commit
> > commit 2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c
> > Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Date:   Wed Dec 22 14:18:50 2010 +0800
> > 
> >     futex,plist: Pass the real head of the priority list to plist_del()
> >     
> >     Some plist_del()s in kernel/futex.c are passed a faked head of the
> >     priority list.
> >     
> >     It does not fail because the current code does not require the real
> >     head in plist_del(). The current code of plist_del() just uses the
> >     head for
> > 
> > checking,
> > 
> >     so it will not cause a bad result even when we use a faked head.
> >     
> >     But it is undocumented usage:
> >     
> >     /**
> >     
> >      * plist_del - Remove a @node from plist.
> >      *
> >      * @node:   &struct plist_node pointer - entry to be removed
> >      * @head:   &struct plist_head pointer - list head
> >      */
> >     
> >     The document says that the @head is the "list head" head of the
> >     priority
> > 
> > list.
> > 
> >     In futex code, several places use "plist_del(&q->list,
> >     &q->list.plist);", they pass a fake head. We need to fix them all.
> >     
> >     Thanks to Darren Hart for many suggestions.
> >     
> >     Acked-by: Darren Hart <dvhart@linux.intel.com>
> >     Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
> >     LKML-Reference: <4D11984A.5030203@cn.fujitsu.com>
> >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > :
> > :040000 040000 78d47de377f8da1c131007a17ca915fbd13f7ff6
> > 
> > ffac93205aaf22fda0667d6395c8da7c7bf692e4 M      kernel


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
