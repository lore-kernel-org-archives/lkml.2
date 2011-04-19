Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1DSIG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:06:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47939 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751377Ab1DSIGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:06:23 -0400
Date: Tue, 19 Apr 2011 09:06:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@queued.net>
Cc: cliff.cai@analog.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        lrg@slimlogic.co.uk, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
Message-ID: <20110419080629.GA16357@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <20110307145931.GK13471@opensource.wolfsonmicro.com>
 <20110418171505.4b1699f3@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418171505.4b1699f3@queued.net>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 05:15:05PM -0700, Andres Salomon wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > Given the number of people looking at this from various angles I'd
> > expect to see some sort of progress this year (probably in the next
> > quater or so), but obviously no guarantees.

> Out of curiosity, has any progress been made on this?

No, it's only been a month.

> What would actually cause the firmware to change?  Would the userspace
> application that's currently driving the codec know that it needs to
> load a new firmware, or will there be multiple applications potentially
> interacting with the codec (with only one driving it, and another
> deciding that the firmware should change)?

Clearly something in userspace will need to be able to do this.

> One can imagine two different types of APIs depending upon the answers
> to those questions.  If the application driving the codec is also
> changing the firmware, a simple 'echo new_firmware_name.bin >
> /sys/.../filter_coeff' (or equivalent ALSA function)

Using sysfs isn't going to fly for all the reasons discussed upthread -
it's not enumerable and it's not going to cope with large coefficient
sets.

> However, if multiple applications are going to be interacting with
> the codec, I'd imagine we'd need something more complex; perhaps a hook
> in snd_soc_dai_ops that's called anytime stream state changes?  That

Using the ops isn't going to work as there's no reason a coefficient set
has to be associated with a DAI.
