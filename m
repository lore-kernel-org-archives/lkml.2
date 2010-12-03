Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0LCNuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:50:35 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:49665 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab0LCNue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:50:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Fri, 3 Dec 2010 14:50:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012031119.36771.laurent.pinchart@ideasonboard.com> <201012031306.18520.hverkuil@xs4all.nl>
In-Reply-To: <201012031306.18520.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012031450.59137.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Adding by the original CC list which was dropped by mistake.

On Friday 03 December 2010 13:06:18 Hans Verkuil wrote:
> On Friday, December 03, 2010 11:19:36 Laurent Pinchart wrote:
> > On Sunday 28 November 2010 16:57:00 you wrote:
> > > On Sunday, November 28, 2010 13:34:45 Laurent Pinchart wrote:
> > > > On Friday 26 November 2010 15:14:42 Mark Brown wrote:
> > > > > On Fri, Nov 26, 2010 at 03:13:36PM +0100, Laurent Pinchart wrote:
> > > > > > On Thursday 25 November 2010 16:49:52 Mark Brown wrote:
> > > > > > > On Thu, Nov 25, 2010 at 04:40:41PM +0100, Laurent Pinchart 
wrote:
> > > > > > > > It's supposed to reflect whether the link can carry data.
> > > > > > > > Think of the active flag as a valve on a pipe. If the valve
> > > > > > > > is open, the link is active. If the valve is closed, the
> > > > > > > > link is inactive. This is unrelated to whether water
> > > > > > > > actually flows through the pipe.
> > > > > > > 
> > > > > > > This seems a confusing name, then - I'd expect an active link
> > > > > > > to be one which is actually carrying data rather than one
> > > > > > > which is available to carry data.  How a more neutrally worded
> > > > > > > name such as "connected" (which is what ASoC uses currently)?
> > > > > > 
> > > > > > In our current vocabulary "connected" refers to entities between
> > > > > > which a link exist, regardless of the link state ("valve opened"
> > > > > > or "valve closed"). I'm not totally happy with "active" either,
> > > > > > but if we replace it with "connected" we need another word to
> > > > > > replace current uses of "connected".
> > > > > 
> > > > > Linked?
> > > > 
> > > > That's a good option. Hans, do you want to comment on this ?
> > > 
> > > Fine by me! It's better than 'active'.
> > 
> > Just to confirm thinks, Mark's proposal is to replace 'connected' by
> > 'linked' and 'active' by 'connected'. Are we on the same page here ?
> 
> Yes, but when I read it back it does not make me happy. 'Connected' and
> 'linked' basically have the same meaning in English.

I unfortunately agree that it's a bit confusing :-(

> I really like your analogy with valves, so perhaps we should use either
> 'linked' or 'connected' to describe that two entities are, well,
> linked/connected, and use the 'open' and 'closed' terminology to describe
> whether a link/connection is open (data can flow) or closed (no data can
> flow).

I don't really like the open/closed terminology to describe links.

I can think of two analogies: pipes with valves that can be opened/closed, or 
cables that can be connected/disconnected.

In the first case, connected/linked can be used to specify the pipes that 
exist in the system, but I'm not happy with open/closed.

In the second case, connected/linked can be used to specify whether a cable is 
connected, but in that case we will need another word to describe whether two 
pads are connectable or not.

> I have a slight preference for 'link' over 'connection', but that's mostly
> because it is a shorter word :-)

Link refers to a pipe/possible cable connection. It's an object on both the 
kernel side and the userspace side. Using the above analogies, tt makes sense 
to use the word 'linked' to refer to two pads that are connected by a pipe, or 
between which a cable can be connected.

Now we need a word to descripe whether the valve is opened or closed, or 
whether the cable is connected or not. I don't really like 'open'/'closed' for 
the first analogy. 'connected' would make sense for the second analogy, but it 
can indeed be a bit confusing.

Thoughts ?

-- 
Regards,

Laurent Pinchart
