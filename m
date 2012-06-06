Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2FFO1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:27:54 -0400
Received: from natasha.panasas.com ([67.152.220.90]:53244 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2FFO1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:27:51 -0400
Message-ID: <4FCF6748.6020005@panasas.com>
Date: Wed, 6 Jun 2012 17:20:56 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <jslaby@suse.cz>, <gregkh@linuxfoundation.org>, <alan@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <viro@zeniv.linux.org.uk>
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at>
In-Reply-To: <1338841657-30358-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 11:27 PM, Richard Weinberger wrote:

> This patch set moves the UML console driver to the new TTY port interface.
> It does ref counting and uses the tty_port_*-helpers.
> Please note, it's not yet UML mconsole safe!
> 
> Anyway, I see some really strange things and I'm not sure whether my patch
> is sane or not...
> 
> If I implement tty_operations->hangup() the following happens:
> 
> FC12:
> 	Login on tty0 works fine.
> 	On all other ttys login works but bash dies because of of -EIO.
> 	After vhangup() the tty returns -EIO upon read()/write().
> FC16:
> 	Login broken on all ttys (bash dies with EIO like on FC12).
> 	If I start UML with rootfs read-only login works on tty0. - WTF?!
> Debian 6.0:
> 	Login works perfectly fine on all ttys
> 
> Without tty_operations->hangup() the following happens:
> FC12:
> 	Login on tty0 works fine.


Horray I'm back to my old self. Thanks I'll give it a run
and report of any new problems

Thanks a million Richard
Boaz

> 	mingetty is unable to start on anything else than tty0.
> 	It exits after a few seconds.
> FC16:
> 	Unable to start any mingetty (like on FC12 it exits after a few seconds)
> 	With read-only rootfs mingetty starts at least on tty0 and login works. (Again, WTF?)
> Debian 6.0
> 	Login works perfectly fine on all ttys.
> 
> I have no idea what's the root cause of this, there seems to be a lot of black magic
> involved.
> Alan, do you think the issues are caused by Fedora's broken user space?
> How can we fix this?
> 
> Thanks,
> //richard (wearing a voodoo priests robe)
> 
> [PATCH 1/6] TTY: um/line, add tty_port
> [PATCH 2/6] TTY: um/line, use tty from tty_port
> [PATCH 3/6] um: remove line_ioctl()
> [PATCH 4/6] um: Remove dead code
> [PATCH 5/6] um: fully use tty_port
> [PATCH 6/6] um: remove count_lock
> 
> ------------------------------------------------------------------------------
> Live Security Virtual Conference
> Exclusive live event will cover all the ways today's security and 
> threat landscape has changed and how IT managers can respond. Discussions 
> will include endpoint security, mobile security and the latest in malware 
> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel


