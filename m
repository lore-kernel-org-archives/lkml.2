Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1AVWR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:17:56 -0500
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:57249 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881Ab1AVWRz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:17:55 -0500
X-SpamScore: -33
X-BigFish: VPS-33(zzbb2cK542N1432N98dN4015L9371Pzz1202hzz8275dh8275chz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
x-cr-puzzleid: {9342BA30-3BFE-4984-905B-B6C263063CDE}
x-cr-hashedpuzzle: HDMU H24v K613 LVBO LlK4 L9rW MMSK MPDk M7vZ NI4Y PX1g QAVB QVZs Ra5L Rw8j UGIk;2;agBqAEAAYwBoAGEAbwBzAGIAaQB0AHMALgBuAGUAdAA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{9342BA30-3BFE-4984-905B-B6C263063CDE};bABpAG4AbgBqAEAAeABpAGwAaQBuAHgALgBjAG8AbQA=;Sat, 22 Jan 2011 22:17:39 GMT;UgBFADoAIABjAG8AbgBzAG8AbABlACAAcAByAG8AYgBsAGUAbQA/ACwAIABjAGwAbwBzAGUAKAAyACkAIABoAGEAbgBnAHMAIAAvAHMAYgBpAG4ALwBpAG4AaQB0AA==
Content-Class: urn:content-classes:message
Subject: RE: console problem?, close(2) hangs /sbin/init
Date: Sat, 22 Jan 2011 15:17:39 -0700
In-Reply-To: <alpine.LNX.2.00.1101222312560.7746@swampdragon.chaosbits.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: console problem?, close(2) hangs /sbin/init
Thread-Index: Acu6ga2EfH4LKA61T+qZbvGFKc/MZAAAA2nw
References: <7110b8bd-1411-4a92-81b7-1a76f5d5cb65@SG2EHSMHS005.ehs.local> <alpine.LNX.2.00.1101222312560.7746@swampdragon.chaosbits.net>
From: John Linn <John.Linn@xilinx.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Jan 2011 22:17:46.0962 (UTC) FILETIME=[32B7EB20:01CBBA82]
X-RCIS-Action: ALLOW
Message-ID: <3caedaa7-fa80-400f-bac6-a8c635d00c4d@SG2EHSMHS004.ehs.local>
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

2.6.37, but I also tried a 2.6.35 build.

> 
> >with a busybox root file system using
> > inittab.  When I move to a non-busybox init (sysvinit), I see init
> > hanging when doing a close of standard error very early when it
starts.
> > I have debugged it with GDB but not found the source of the hang as
it's
> > in the kernel it appears.
> >
> > To debug this, I use init=/bin/sh on the kernel command line, then
exec
> > init to start it. The same root file system works on another board
with
> > a different kernel.
> 
> What other kernel version exactely?

2.6.28, but others have told them tested the same root file system on
2.6.37 kernels on other boards fine.

It's a poky based root file system for ARM.

I've tried comparing kernel configs to try look for differences without
much luck yet.

Thanks,
John

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


