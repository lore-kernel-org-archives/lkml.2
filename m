Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0JLJjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:39:25 -0400
Received: from ifrit.dereferenced.org ([66.212.21.15]:38920 "EHLO
	ifrit.dereferenced.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab0JLJjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:39:24 -0400
Date: Tue, 12 Oct 2010 13:39:19 +0400 (MSD)
From: William Pitcock <nenolod@dereferenced.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
        kernel@kolivas.org
Message-ID: <8358526.1721286876359420.JavaMail.root@ifrit.dereferenced.org>
In-Reply-To: <20101012093044.GD20366@elte.hu>
Subject: Re: [PATCH try 5] CFS: Add hierarchical tree-based penalty.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.202.104.35]
X-Mailer: Zimbra 6.0.0_BETA2_1547.UBUNTU8 (ZimbraWebClient - FF3.0 (Linux)/6.0.0_BETA2_1547.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- "Ingo Molnar" <mingo@elte.hu> wrote:

> * William Pitcock <nenolod@dereferenced.org> wrote:
> 
> > Inspired by the recent change to BFS by Con Kolivas, this patch
> causes 
> > vruntime to be penalized based on parent depth from their root task
> 
> > group.
> > 
> > I have, for the moment, decided to make it a default feature since
> the 
> > design of CFS ensures that broken applications depending on task 
> > enqueue behaviour behaving traditionally will continue to work.
> 
> Just curious, is this v5 submission a reply to Peter's earlier review
> of 
> your v3 patch? If yes then please explicitly outline the changes you
> did 
> so that Peter and others do not have to guess about the direction your
> 
> work is taking.

I just did that in the email I just sent.  Simply put, I was talking with
Con a few weeks ago about the concept of having a maximum amount of service
for all threads belonging to a process.  This did not work out so well, so
Con proposed penalizing based on fork depth, which still allows us to maintain
interactivity with make -j64 running in the background.

Actually, I lie: it works great for server scenarios where you have some
sysadmin also running azureus.  Azureus gets penalized instead, but other
apps like audacious get penalized too.

William
