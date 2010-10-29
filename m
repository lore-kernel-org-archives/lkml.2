Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522Ab0J2Nzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:55:49 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2143 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab0J2Nzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:55:47 -0400
X-SpamScore: -11
X-BigFish: VS-11(z3b68iz1432N98dNzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
Message-ID: <4CCAD244.3060600@freescale.com>
Date: Fri, 29 Oct 2010 08:55:16 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
References: <4CC893CD.7020701@freescale.com> <20101027231948.5e62dd09@lxorguk.ukuu.org.uk> <4CC9D074.3060108@freescale.com>
In-Reply-To: <4CC9D074.3060108@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2010 13:55:50.0048 (UTC) FILETIME=[FE86CA00:01CB7770]
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> I see something weird, though.  I lose the console after I log in:
> 
> p4080 login: root
> Password:
> ehv_bc_tty_open:442 ttys=dce50000 stdout_irq=68
> ehv_bc_tty_close:450 tty=dce50000
> ls

I've done a little more debugging, and it's even stranger than I thought.  The
console is only half missing.

What's missing is my shell prompt, and a few other things.  I can type in
commands, though.  The prompt returns, however, if I 'cd' to the root direcetory.

In addition, the 'set' command only displays some of the environment variables.
 The others produce blank lines.  Here's a sample output.

Do you have any idea what's going on?  This is just so bizarre.


p4080 login: root
Password:
ehv_bc_tty_open:446 ttys=dcf0e400 stdout_irq=66
ehv_bc_tty_open:449 ttys->driver_data=(null) &ttyport=c0558f34
ehv_bc_tty_close:455 tty=dcf0e400
ls
test_setkey

echo $PATH

echo $PS1
[\u@\h \W]\$
set
BASH=/bin/sh


COLUMNS=80
DIRSTACK=()
EUID=0
GROUPS=()

HISTFILESIZE=500
HISTSIZE=500
HOME=/root
HOSTNAME=p4080
HOSTTYPE=powerpc
IFS='
'
LINES=24
LOGNAME=root

MAILCHECK=60
OPTERR=1
OPTIND=1
OSTYPE=linux-gnu



PPID=1

PS2='> '
PS4='+ '
PWD=/root
SHELL=/bin/sh

SHLVL=1
TERM=screen
UID=0
USER=root
_='\W]\$'

cd /
[root@p4080 /]# pwd
/
[root@p4080 /]# set
BASH=/bin/sh


COLUMNS=80
DIRSTACK=()
EUID=0
GROUPS=()

HISTFILESIZE=500
HISTSIZE=500
HOME=/root
HOSTNAME=p4080
HOSTTYPE=powerpc
IFS='
'
LINES=24
LOGNAME=root

MAILCHECK=60
OLDPWD=/root
OPTERR=1
OPTIND=1
OSTYPE=linux-gnu



PPID=1

PS2='> '
PS4='+ '
PWD=/
SHELL=/bin/sh

SHLVL=1
TERM=screen
UID=0
USER=root
_=pwd
[root@p4080 /]#
[root@p4080 /]# echo $HOME
/root
[root@p4080 /]# ls -l /root

[root@p4080 /]# cd /root
ls -l

cd /
[root@p4080 /]# ls -l

















[root@p4080 /]#

-- 
Timur Tabi
Linux kernel developer at Freescale

