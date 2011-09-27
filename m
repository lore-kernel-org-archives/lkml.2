Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1I0J5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:57:31 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60790 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab1I0J5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:57:30 -0400
Subject: Re: [PATCH] spinlock: rm duplicated preempt en/disable for bottom
 half
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, joe@perches.com, tglx@linutronix.de
In-Reply-To: <CAA_GA1czUfsP-mr74zMsLbjifx2Gsa-Fnv+V4yjfa0PUpyg-ow@mail.gmail.com>
References: <1317110185-9219-1-git-send-email-lliubbo@gmail.com>
	 <1317114837.15383.1.camel@twins>
	 <CAA_GA1czUfsP-mr74zMsLbjifx2Gsa-Fnv+V4yjfa0PUpyg-ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 11:57:41 +0200
Message-ID: <1317117461.2541.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 27 septembre 2011 à 17:40 +0800, Bob Liu a écrit :
> On Tue, Sep 27, 2011 at 5:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2011-09-27 at 15:56 +0800, Bob Liu wrote:
> >> local_bh_en/disable() has already deal with en/disable preempt, so rm the
> >> dumplicated one from spinlock_api_up/smp.h head file.
> >
> > I bet you haven't tried booting this..  you just broke stuff like:
> >
> 
> I only tried it on blackfin arch and can boot successfully
> although it's a simple single-cpu ystem.
> 
> >  spin_lock_bh(&foo);
> >  /* do crap */
> >  spin_unlock(&foo);
> >  /* do some other crap */
> >  local_bh_enable();
> >
> >
> > And yes that does happen.
> 
> Could you please give an example?  I did a simple search but no result.
> I thought the user should use spin_lock_bh()/spin_unlock_bh() in pairs.
> 

You probably can find such use in network stack.

net/ipv4/inet_hashtables.c  function  __inet_hash_connect()



