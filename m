Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1BHNI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:08:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60941 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752811Ab1BHNIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:08:25 -0500
Date: Tue, 8 Feb 2011 13:08:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Adding bluetooth PCM interface support to ASoC (Was: Re:
 [PATCH 6/7] ASoC: Samsung: neo1973_gta02: Fix bluetooth DAI registration)
Message-ID: <20110208130823.GG29850@opensource.wolfsonmicro.com>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
 <1297033463-14577-6-git-send-email-lars@metafoo.de>
 <20110207115906.GD10564@opensource.wolfsonmicro.com>
 <4D5023A4.3020209@metafoo.de>
 <20110207170213.GP10564@opensource.wolfsonmicro.com>
 <4D502DBF.3050205@metafoo.de>
 <20110207174950.GQ10564@opensource.wolfsonmicro.com>
 <4D50355A.60500@metafoo.de>
 <20110207181702.GR10564@opensource.wolfsonmicro.com>
 <4D50785A.7050801@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D50785A.7050801@metafoo.de>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 11:55:22PM +0100, Lars-Peter Clausen wrote:

> I did some research on the topic and it seems that this is a pretty common
> setup in embedded devices.

Yes, this is a totally vanilla setup except that for modern hardware the
baseband is connected digitally also.

> But the bluetooth audio support seems to be entirely written in userspace. The
> in-kernel bluetooth drivers in general seem only to provide a common interface
> to the underlying hardware and all of the higher level functionality seems to
> be implemented in userspace.
> So right now I have no idea where to start if one wanted to add a ASoC driver
> which did the bt-dai configuration.

The obvious starting point would seem to be to provide a driver which
allows userspace to tell the kernel about configuration changes - that's
what we're doing at the minute for the trivial case where the hardware
doesn't change configuration.  We could then look at pushing more of the
code into the kernel if that made sense.
