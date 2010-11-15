Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0KOCKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:10:31 -0500
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:43795 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932416Ab0KOCKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:10:30 -0500
From: Bruno Randolf <br1@einfach.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average (EWMA) function
Date: Mon, 15 Nov 2010 11:10:45 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kevin.granade@gmail.com, "John W. Linville" <linville@tuxdriver.com>
References: <4CDC333E.4070104@s5r6.in-berlin.de> <20101114133029.E008.A69D9226@jp.fujitsu.com> <4CDFA2FC.40603@s5r6.in-berlin.de>
In-Reply-To: <4CDFA2FC.40603@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151110.46007.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun November 14 2010 17:51:08 Stefan Richter wrote:
> >>> Why do ewma_init() and ewma_add() return their first argument?  They
> >>> look to me like they can be straight-forward void functions.
> >> 
> >> You are right, for ewma_init() it does not make sense.
> >> 
> >> For ewma_add() I think it does. This has been discussed before (e.g.
> >> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg09124.html).
> >> Some people might want to get the value when they add a sample by using
> >> ewma_get(ewma_add(&ewma, val));
> >> 
> > 	ewma_add(&ewma, val);
> > 	ewma_get(&ewma);
> > 
> > is enough simpler and cleaner. I don't oppse this :)
> 
> There are more candidate colors for the bike shed: :-)
>   - an ewma_add_return could do what ewma_get(ewma_add(...)) is meant for,

I think this would be overkill. We're just talking about a return pointer...

>   - or ewma_add itself could return the result.

The way I intend to use it, I will add samples much more often than I get a 
value, so IMHO it makes sense to split it.

> BTW, isn't "get" more usually used as a prefix for these kinds of functions
> in kernel APIs?  "get" as a suffix more often means "get a reference"
> alias increase reference count rather than "get the value".

Umm. I don't know and honstly I don't care. I think the API ewma_* is 
consistent. If you have a good reason to change it please let me know, 
otherwise i'd just leave it like it is now.

bruno
