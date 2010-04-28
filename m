Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0D1NCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:02:37 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:44508 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0D1NCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:02:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH 10/10] bkl: Fix-up compile problems as a result of the bkl-pushdown.
Date: Wed, 28 Apr 2010 15:02:49 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33; KDE/4.4.2; x86_64; ; )
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Arnd Bergmann" <arnd@arndb.de>, "John Kacur" <jkacur@redhat.com>,
       "lkml" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Jan Blunck" <jblunck@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Media Mailing List" <linux-media@vger.kernel.org>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com> <4BD82905.2020408@infradead.org> <9bc05165144f526ccb015c1ae4f44f9b.squirrel@webmail.xs4all.nl>
In-Reply-To: <9bc05165144f526ccb015c1ae4f44f9b.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004281502.51174.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Wednesday 28 April 2010 14:37:10 Hans Verkuil wrote:
> > Arnd Bergmann wrote:

[snip]

> >> Mauro, does this patch make sense to you? It would be good to have your
> >> Ack so we can queue this in the series leading to the removal of the
> >> ->ioctl file operation. We can also do the minimal change and let you
> >> take care of fixing this up in a different way in your own tree.
> > 
> > We had a similar discussion a while ago at linux-media. The idea is to do
> > it on a deeper level, changing the drivers to not need to use KBL.
> > Hans is working on those patches. Not sure about the current status.
> 
> I'm waiting for the event patch series from Sakari to go in before I can
> continue working on this.
> 
> > Anyway, I think that the better is to apply first your patch, to avoid
> > breaking your patch series, and then ours, as we may otherwise have some
> > conflicts between your tree and drivers/media git tree.
> 
> I have no real problem with this patch, as long as people realize that
> this only moves the BKL from one place to another and does not really fix
> any drivers.

Seems that Arnd was more convincing than me. I've submitted the exact same 
patch a while ago :-)

Of course this doesn't solve the BKL issue, but it pushes it one level down, 
closer to the drivers. Higher levels can then stop caring about it. Of course 
lower levels will still need to remove the BKL.

-- 
Regards,

Laurent Pinchart
