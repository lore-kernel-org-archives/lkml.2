Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0D1OrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:47:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0D1OrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:47:03 -0400
Message-ID: <4BD84A56.6060806@infradead.org>
Date: Wed, 28 Apr 2010 11:46:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/10] bkl: Fix-up compile problems as a result of the
 bkl-pushdown.
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com> <4BD82905.2020408@infradead.org> <9bc05165144f526ccb015c1ae4f44f9b.squirrel@webmail.xs4all.nl> <201004281502.51174.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004281502.51174.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 28 April 2010 14:37:10 Hans Verkuil wrote:
>>> Arnd Bergmann wrote:
> 
> [snip]
> 
>>>> Mauro, does this patch make sense to you? It would be good to have your
>>>> Ack so we can queue this in the series leading to the removal of the
>>>> ->ioctl file operation. We can also do the minimal change and let you
>>>> take care of fixing this up in a different way in your own tree.
>>> We had a similar discussion a while ago at linux-media. The idea is to do
>>> it on a deeper level, changing the drivers to not need to use KBL.
>>> Hans is working on those patches. Not sure about the current status.
>> I'm waiting for the event patch series from Sakari to go in before I can
>> continue working on this.
>>
>>> Anyway, I think that the better is to apply first your patch, to avoid
>>> breaking your patch series, and then ours, as we may otherwise have some
>>> conflicts between your tree and drivers/media git tree.
>> I have no real problem with this patch, as long as people realize that
>> this only moves the BKL from one place to another and does not really fix
>> any drivers.
> 
> Seems that Arnd was more convincing than me. I've submitted the exact same 
> patch a while ago :-)

Same patch, different situation ;)

> Of course this doesn't solve the BKL issue, but it pushes it one level down, 
> closer to the drivers. Higher levels can then stop caring about it. Of course 
> lower levels will still need to remove the BKL.

Yes. This patch doesn't change anything in practice, but it allows RT people
to keep working on their series of changes, giving us a little more time to 
work on a definitive solution. If nacked, we would need to send an alternative
patch for them, and, as this is not ready (and such patch applied via RT tree would
likely cause merge conflicts with our patches), the better is to just ack and keep 
writing the patch that will solve the issue.

Your patch were very useful, as it started the discussions for the BKL removal
on drivers/media drivers.

-- 

Cheers,
Mauro
