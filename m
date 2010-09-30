Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0I3LiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:38:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab0I3LiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:38:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: interpreting semantics of ipc system call
Date: Thu, 30 Sep 2010 13:37:55 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andreas Saebjoernsen <andreas@digitalplaywright.com>,
        linux-kernel@vger.kernel.org
References: <AANLkTik8auzhRB00fRWxbmZKOKg+T87ZZa07ydDAGp=f@mail.gmail.com> <20100930100405.GB5265@cr0.nay.redhat.com>
In-Reply-To: <20100930100405.GB5265@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201009301337.55511.arnd@arndb.de>
X-Provags-ID: V02:K0:iL/ez1ELNQCH7vp3lSPqe18VulXp5/L31jXSaZOgCJM
 3ObRgDloAGBidyiLQP8URrPSJccHbkwpvYjPrwDMDcdsUuBzBO
 J34lLJaYj9Y1oDzQq11kTsvv78uLrDpO6cC2Z97mqSQh3f4wWo
 wVaStVeBk8NtGp/83YoXhND+LCFcqBO9IXNoPVUPN9i3e/0Stq
 SVIp1PoDBO4dnuK9xUgtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 September 2010, Américo Wang wrote:
> On Wed, Sep 29, 2010 at 03:03:11PM -0700, Andreas Saebjoernsen wrote:
> >We are developing a simulator that can simulate any specimen x86 linux program.
> >Our simulator has a simulated memory, unlike the concrete memory state of
> >tools like Valgrind, so that we can do concrete symbolic execution. Instead of
> >reimplementing the system calls we marshal the system calls called by
> >the specimen.
> >
> >I am currently working on marshaling calls to the ipc system call (system
> >call 117) which has the following signature
> >
> >int ipc(unsigned int call, int first, int second, int third, void
> >*ptr, long fifth)
> >
> >I have a problem interpreting what the size is of the data structure
> >pointed to by
> >the 'void*', and I have been unable to locate good documentation or code on the
> >semantics of this system call.
> 
> 
> Take a look at ipc/syscall.c, that pointer will be interpreted to different
> data structures when you pass different arguments to 'call'.

Right. Note that you can ignore the version field for all practical
purposes and consider it constant.

	Arnd
