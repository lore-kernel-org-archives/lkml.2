Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1IZVrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:47:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40244 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab1IZVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:47:40 -0400
Date: Mon, 26 Sep 2011 22:47:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Leo Yan <leoy@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Questions for dummy codec driver
Message-ID: <20110926214738.GA3517@opensource.wolfsonmicro.com>
References: <1316502540.4269.1.camel@phoenix>
 <4E794A96.9040206@marvell.com>
 <20110921125607.GC25620@sirena.org.uk>
 <4E7A9276.803@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7A9276.803@marvell.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:42:14AM +0800, Leo Yan wrote:

> On our platform, there have some devices (like hdmi/bt) do not need
> config from the CODEC driver, they have their own s/w stack and
> interface to configure; for the audio driver, just need to set the
> I2S/PCM timing for them. So if there have a common dummy codec
> driver, then it can meet our requirement well. Otherwise, there will
> have some duplicate codes for these dummy codecs.

The general thought here has been that for dumb CODECs the boilerplate
is sufficiently small and simple to mean that the discoverability from
writing a skeletal driver outweighs the cost of having it kicking around
- while there is some boilerplate there it's easier for someone to grab
and use this code than it is to work out how exactly to translate the
datasheets into code each time they encounter the part.  However, a
sufficiently well written generic driver would maintain that advantage
while reducing the duplication.
