Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1H2OFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:05:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57007 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab1H2OFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:05:30 -0400
X-Sasl-enc: dRhNKpgAxVVC9HnRUBDXainlizpw63Pfp7ve5r64Il9/ 1314626729
Message-ID: <4E5B9CB0.4090708@ladisch.de>
Date: Mon, 29 Aug 2011 16:05:36 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] sound: usb: mixer: increase control transfer timeout
References: <20110829122320.GX13925@legolas.emea.dhcp.ti.com>	<1314621110-19367-1-git-send-email-balbi@ti.com> <CABb+yY15qrszsbJSGGFra7mrVRO_oQPUhNT=U7TNpyoYikABPw@mail.gmail.com>
In-Reply-To: <CABb+yY15qrszsbJSGGFra7mrVRO_oQPUhNT=U7TNpyoYikABPw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jassi Brar wrote:
> On Mon, Aug 29, 2011 at 6:01 PM, Felipe Balbi <balbi@ti.com> wrote:
> > 100ms might not be enough for slower devices. Increasing
> > timeout to 1000ms doesn't seem like overkill.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >
> > Changes since v1:
> >  . Increase all 100ms timeout to 1000ms
> >
> >  sound/usb/mixer.c        |    4 ++--
> >  sound/usb/mixer_quirks.c |   10 +++++-----
> >  2 files changed, 7 insertions(+), 7 deletions(-)

The calls in mixer_quirks.c are device-specific and known to work, so
none of them actually require a longer timeout. However, increasing
their timeout doesn't hurt either, and ...

> > +                                   buf, val_len, 1000) >= val_len) {
> > +                                   buf, val_len, 1000) >= 0) {
> > +                             !value, 0, NULL, 0, 1000);
> > +                             !value, 0, NULL, 0, 1000);
> > +                             value, index + 2, NULL, 0, 1000);
> > +                                     jacks[i].unitid << 8, buf, 3, 1000);
> > +                             50, 0, &new_status, 1, 1000);
> 
> How about also converting to use a local define for timeout value ?

... now that _all_ calls to snd_usb_ctl_msg use the same timeout value,
we could just as well drop this parameter.


Regards,
Clemens
