Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1EOV1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 17:27:06 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3033 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1EOV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 17:27:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH RFC v2] radio-sf16fmr2: convert to generic TEA575x interface
Date: Sun, 15 May 2011 23:26:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
References: <201105140017.26968.linux@rainbow-software.org> <201105141206.51832.hverkuil@xs4all.nl> <201105152218.24041.linux@rainbow-software.org>
In-Reply-To: <201105152218.24041.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105152326.33925.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 15, 2011 22:18:21 Ondrej Zary wrote:
> Thanks, it's much simpler with the new control framework.
> Do the negative volume control values make sense? The TC9154A chip can
> attenuate the volume from 0 to -68dB in 2dB steps.

It does make sense, but I think I would offset the values so they start at 0.
Mostly because there might be some old apps that set the volume to 0 when they
want to mute, which in this case is full volume.

I am not aware of any driver where a volume of 0 isn't the same as the lowest
volume possible, so in this particular case I would apply an offset.

I will have to do a closer review tomorrow or the day after. I think there are
a few subtleties that I need to look at. Ping me if you haven't heard from me
by Wednesday. I would really like to get these drivers up to spec now that I
have someone who can test them, and once that's done I hope that I never have
to look at them again :-) (Unlikely, but one can dream...)

Regards,

	Hans
