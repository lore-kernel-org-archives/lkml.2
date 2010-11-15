Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0KOG5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:57:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51712 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0KOG5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:57:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert oom rewrite series
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
In-Reply-To: <20101114181905.bc5b44f9.akpm@linux-foundation.org>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org>
Message-Id: <20101115113238.BF06.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 15:57:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Nov 2010 09:54:14 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > 2010/11/13 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> > > >
> > > > Please apply this. this patch revert commits of oom changes since v2.6.35.
> > > 
> > > I'm not getting involved in this whole flame-war. You need to convince
> > > Andrew, who has been the person everything went through.
> > 
> > I wonder why he deep silence.
> 
> Nothing to say, really.  Seems each time we're told about a bug or a
> regression, David either fixes the bug or points out why it wasn't a
> bug or why it wasn't a regression or how it was a deliberate behaviour
> change for the better.

Of cource, I denied. He seems to think number of email is meaningful than
how talk about. but it's incorrect and makes no sense. Why not? Also, He
have to talk about logically. "Hey, I think it's not bug" makes no sense.
Such claim don't solve anything. userland is still unhappy. Why not?
I want to quickly action.

I would like to suggest they join and contribute any distro kernel 
maintainance team. Many community based distribution welcome to developrs.
And a bugfix work tell them a lot of thing. which usecase are freqently used,
which bug reports are fequently raised, etc.

That said, If anyone want to change userland ABI, Be carefully. They have
to investigate userland usecase carefully and avoid to break them carefully 
again. If someone think "hey, It's no big matter. userland rewritten can solve
an issue", I strongly disagree. they don't understand why all of userland 
applications rewritten is harmful.



> I just haven't seen any solid reason to be concerned about the state of
> the current oom-killer, sorry.

You can't say "I haven't seen". I always cced you. 


> I'm concerned that you're concerned!  A lot.  When someone such as
> yourself is unhappy with part of MM then I sit up and pay attention. 
> But after all this time I simply don't understand the technical issues
> which you're seeing here.

You should have read my patch descriptions which I sent and my e-mail.


1) About two month ago, Dave hansen observed strange OOM issue because he
   has a big machine and ALL process are not so big. thus, eventually all 
   process got oom-score=0 and oom-killer didn't work.

   https://kerneltrap.org/mailarchive/linux-driver-devel/2010/9/9/6886383

   DavidR changed oom-score to +1 in such situation. 

   http://kerneltrap.org/mailarchive/linux-kernel/2010/9/9/4617455

   But it is completely bognus. If all process have score=1, oom-killer fall
   back to purely random killer. I expected and explained his patch has
   its problem at half years ago. but he didn't fix yet.

2) Also half years ago, I did explained oom_adj is used from multiple 
   applications. And we can't break them. But DavidR didn't fix.

3) Also about four month ago, I and kamezawa-san pointed out his patch
   don't work on memcg. It also haven't been fixed.


In the other hand, You can't explain what worth OOM-rewritten patch has. 
Because there is nothing. It is only "powerful"(TM) for Google. but 
instead It has zero worth for every other people. Here is just technical 
issue. Bah.



And, I just don't understand why some people try to remove or obsolate
oom_adj. It's just eight lines code and It's used from multiple applications.
There is no reason to break userland at all.
--------------------------------------------------------
 178        /*
 179         * Adjust the score by oom_adj.
 180         */
 181        if (oom_adj) {
 182                if (oom_adj > 0) {
 183                        if (!points)
 184                                points = 1;
 185                        points <<= oom_adj;
 186                } else
 187                        points >>= -(oom_adj);
 188        }
--------------------------------------------------------


If you still have a question, please ask me. maybe I can answer all of 
your question.



