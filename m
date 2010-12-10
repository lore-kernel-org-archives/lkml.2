Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0LJQfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:35:12 -0500
Received: from smtp.nokia.com ([147.243.128.24]:49621 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab0LJQfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:35:10 -0500
Message-ID: <4D0256B4.7010703@maxwell.research.nokia.com>
Date: Fri, 10 Dec 2010 18:35:00 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012071813.35501.hverkuil@xs4all.nl> <20101207175505.GI9689@rakim.wolfsonmicro.main> <201012071911.39270.hverkuil@xs4all.nl> <20101207190328.GA789@rakim.wolfsonmicro.main>
In-Reply-To: <20101207190328.GA789@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark and others!

Mark Brown wrote:
> On Tue, Dec 07, 2010 at 07:11:39PM +0100, Hans Verkuil wrote:
> 
>> Ah, now I understand what you mean. Would 'activated' be better than 'active'?
> 
> Better, yes, though it still sounds a bit like something should be
> actively (IYSWIM) happening.   In the absence of better ideas I could go
> with this.

Activated, to me, sounds like that it has happened as a consequence of
something, and primarily not as a result of a user request.

This flag is also set using MEDIA_IOC_SETUP_LINK ioctl and setting the
flags field would be something like this:

media_link_desc.flags |= MEDIA_LINK_ACTIVATED;

I'd prefer ACTIVE over ACTIVATED, since this may also be set (and is
mostly set) by the user.

But reading this discussion, ACTIVE has not received unanimous approval
either... :\

>> Or perhaps just say: the link 'is on' or the link 'is switched on'?
> 
>> So: ...LINK_SWITCHED_ON (sorry, forgot what the prefix is).
> 
>> Actually, I think 'switched on' is a pretty good description of what is going on
>> in the hardware.
> 
> I prefer activated, this makes me think of power.  Bear in mind that for
> most audio the power is a big portion of the control - either the audio
> is analogue or it looks like it.

What would you think about "ENABLED"? It's simple, quite generic and
thus doesn't explicitly suggest what is the exact effect it has on the
level of the underlying device.

I don't completely like it myself since it would be best to have an
adjective (like "active") but there's none for the word enable, so it
bears the same issues than "activated".

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
