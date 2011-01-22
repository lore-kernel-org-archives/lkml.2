Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1AVWmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:42:15 -0500
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:9344 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750872Ab1AVWmO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:42:14 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275dh8275chz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
x-cr-puzzleid: {0A6DAD8F-7BF8-4B24-8D6D-9C4F1842CB46}
x-cr-hashedpuzzle: AAli Aqo+ DBJ5 EFVL FhGs FmWX FuDB JEDb K4pB MGax QrVl Tbo5 T57D Wi/B XCsB YiC7;2;agBqAEAAYwBoAGEAbwBzAGIAaQB0AHMALgBuAGUAdAA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{0A6DAD8F-7BF8-4B24-8D6D-9C4F1842CB46};bABpAG4AbgBqAEAAeABpAGwAaQBuAHgALgBjAG8AbQA=;Sat, 22 Jan 2011 22:40:25 GMT;UgBFADoAIABjAG8AbgBzAG8AbABlACAAcAByAG8AYgBsAGUAbQA/ACwAIABjAGwAbwBzAGUAKAAyACkAIABoAGEAbgBnAHMAIAAvAHMAYgBpAG4ALwBpAG4AaQB0AA==
Content-Class: urn:content-classes:message
Subject: RE: console problem?, close(2) hangs /sbin/init
Date: Sat, 22 Jan 2011 15:40:25 -0700
In-Reply-To: <alpine.LNX.2.00.1101222312560.7746@swampdragon.chaosbits.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: console problem?, close(2) hangs /sbin/init
Thread-Index: Acu6ga2EfH4LKA61T+qZbvGFKc/MZAAAxdzQ
References: <7110b8bd-1411-4a92-81b7-1a76f5d5cb65@SG2EHSMHS005.ehs.local> <alpine.LNX.2.00.1101222312560.7746@swampdragon.chaosbits.net>
From: John Linn <John.Linn@xilinx.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Jan 2011 22:40:32.0319 (UTC) FILETIME=[6088DCF0:01CBBA85]
X-RCIS-Action: ALLOW
Message-ID: <f472f2eb-0730-43d7-ad97-3ba867694fb5@SG2EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jesper Juhl [mailto:jj@chaosbits.net]
> Sent: Saturday, January 22, 2011 3:14 PM
> To: John Linn
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: console problem?, close(2) hangs /sbin/init
> 
> On Sat, 22 Jan 2011, John Linn wrote:
> 
> > I have a kernel that runs fine
> 
> What kernel exactely?
> 
> >with a busybox root file system using
> > inittab.  When I move to a non-busybox init (sysvinit), I see init
> > hanging when doing a close of standard error very early when it
starts.
> > I have debugged it with GDB but not found the source of the hang as
it's
> > in the kernel it appears.

I seems like it's any of the descriptors for the console, 0, 1, or 2 as
I try to isolate it.
Init closes all 3 when it begins and this is where the problem seems to
start.

At one point during some debug, I saw the kernel spit out a message
about a hung task which
showed tty_lock/mutex_lock_slowpath from a sys_open origin.

I had written it off in the beginning because I don't always see it, but
maybe this is also
a symptom I should be debugging.

> >
> > To debug this, I use init=/bin/sh on the kernel command line, then
exec
> > init to start it. The same root file system works on another board
with
> > a different kernel.
> 
> What other kernel version exactely?
> 
> > I have also noticed that building init with
> > INITDEBUG on so that it forks for debugging makes it work fine. This
> > seems to indicate the device nodes are all fine to me.
> >
> > It seems related to PID 1 and the console device.
> >
> > Adding debug to the kernel in sys_close() shows it hanging in
> > filp_close() and I'm still digging more (maybe locking issue). The
> > console is a serial device with a newer driver which I suspected to
be
> > the issue, but can't see anything wrong.
> >
> > Any hints or similar problems seen would be much appreciated.
> > Thanks,
> > John
> >
> 
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


