Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0LGRN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:13:59 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4827 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0LGRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:13:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Tue, 7 Dec 2010 18:13:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012031450.59137.laurent.pinchart@ideasonboard.com> <20101203145408.GW859@rakim.wolfsonmicro.main>
In-Reply-To: <20101203145408.GW859@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071813.35501.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010 15:54:08 Mark Brown wrote:
> On Fri, Dec 03, 2010 at 02:50:58PM +0100, Laurent Pinchart wrote:
> > On Friday 03 December 2010 13:06:18 Hans Verkuil wrote:
> 
> > > > Just to confirm thinks, Mark's proposal is to replace 'connected' by
> > > > 'linked' and 'active' by 'connected'. Are we on the same page here ?
> 
> > > Yes, but when I read it back it does not make me happy. 'Connected' and
> > > 'linked' basically have the same meaning in English.
> 
> > I unfortunately agree that it's a bit confusing :-(
> 
> It feels like the problem here is that for whatever reason (I'm not sure
> what?) you're trying to come up with verbs for links that are currently
> disconnected - in ASoC we just say we've got paths that exist and then
> we talk about the paths that are connected.  Verbing everything makes it
> all sound active which is confusing when you're talking about links that
> are idle.

OK, let's try this again.

The media controller has entities, entities have pads, and between pads there
are links.

Links can be active (data can flow) or inactive (no data can flow).

Active links can be idle (no data is flowing) or streaming (data is flowing
over the link).

Personally I think this is perfectly clear. The original confusion came from
the word 'active', which I understand means 'streaming' in alsa. By adding
a 'streaming' flag in addition to the active flag I think it will be clear
that 'active' and 'streaming' are two different things.

Regarding 'active': an alternative could be 'connected'. I think it is not
quite as good as 'active' since basically all links are always connected in
the usual sense of the word. It is just that a mux decides which one is
actually working. However, I won't object to using 'connected' instead of
'active' if others prefer that.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
