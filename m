Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1LJHdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 02:33:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:35488 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751170Ab1LJHda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 02:33:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/8V71cxwH8q5cMVtUgAPAGFSA9eINI6sd+SFtb+s
	En7245Bsa/+z7a
Subject: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series
From: Mike Galbraith <efault@gmx.de>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Kalkhof <nkalkhof@web.de>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
In-Reply-To: <4ED4BCD5.3090308@linux.vnet.ibm.com>
References: <492649473.3864850.1322512273580.JavaMail.fmail@mwmweb020>
	 <20111128204412.GM24062@one.firstfloor.org>
	 <4ED4BCD5.3090308@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Dec 2011 08:33:25 +0100
Message-ID: <1323502405.8213.39.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 16:37 +0530, Deepthi Dharwar wrote:
> On 11/29/2011 02:14 AM, Andi Kleen wrote:
> 
> > On Mon, Nov 28, 2011 at 09:31:13PM +0100, Nicolas Kalkhof wrote:
> >> Andi,
> >>
> >> correct. The issue was introduced somewhere between 3.1 final and 3.2-rc1. I've tried to track down the bad commit but so far I haven't been successfull. The only workaround I found is to set the idle boot parameter to mwait and to disable CONFIG_INTEL_IDLE. Somehow the kernel seems to set idle to poll by default - no idea why :-(. I wonder if other mobile sandy bridge cpus are affected as well.
> > 
> > There are only a few changesets affecting drivers/idle
> > 
> > Can you try to git revert 
> > 
> > 46bcfad7a819bd17ac4e831b04405152d59784ab
> > 4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
> > e978aa7d7d57d04eb5f88a7507c4fb98577def77
> > 
> > ?
> > 
> > -Andi
> 
> 
> Hi,
> 
> I am guessing that for workaround just setting the idle boot parameter
> to mwait should work. Have u tested this without disabling
> CONFIG_INTEL_IDLE ?
> 
> Also one thing to note from your logs is, cpu is not entering any of the
> other C states except for POLL. Can you also check if your are enabling
> only POLL for idle. I am able to enter deeper C-states on i5-2540M with
> Intel_Idle enabled.

Seems I accidentally found a way to reproduce, boot with nohz=off.
Q6600 box can be booted nohz=off without ending up as if I'd booted
idle=poll, but boxen using intel_idle() end up using poll_idle().

	-Mike

