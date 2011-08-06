Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab1HFG7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 02:59:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1HFG7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 02:59:19 -0400
Date: Sat, 6 Aug 2011 08:58:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        tglx@linutronix.de, davej@redhat.com, yinghan@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110806065820.GF13220@elte.hu>
References: <20110727135730.GA17717@sgi.com>
 <20110727140523.GA24206@redhat.com>
 <20110727141527.GA8453@sgi.com>
 <20110727155200.GA25381@redhat.com>
 <20110801184542.GA3939@sgi.com>
 <20110805104635.GB13055@elte.hu>
 <20110805131638.GA27779@sgi.com>
 <CAE9FiQWAmjTWGBLrqH9+_AH316Br-McW=PrSyiDWCtSYndL07w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWAmjTWGBLrqH9+_AH316Br-McW=PrSyiDWCtSYndL07w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0001]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Fri, Aug 5, 2011 at 6:16 AM, Jack Steiner <steiner@sgi.com> wrote:
> > Aside from the bogus comment (I'll send a V3 with a fixed comment), does the patch
> > look ok.
> 
> Several months ago, Robin said that he will test updated version
> 
> [PATCH] x86: Make calibrate_delay run in parallel.
> 
> so any reason that you sgi guyes stop that path?

Running calibration in parallel is pretty stupid: cores/threads might 
impact each other and there might be a lot of avoidable noise in the 
results.

Thanks,

	Ingo
