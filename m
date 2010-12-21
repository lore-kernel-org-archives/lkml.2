Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0LURBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:01:37 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:42343 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0LURBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:01:35 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 21 Dec 2010 17:59:56 +0100
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: synaptics - add multi-finger and semi-mt
 support
Message-ID: <20101221165956.GA28702@polaris.bitmath.org>
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se>
 <1292852364-19127-3-git-send-email-rydberg@euromail.se>
 <4D10D75D.80400@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D10D75D.80400@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PV5ZI-00010S-Av.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PV5ZI-00010S-Av 3402b8722917a889f68a254775696365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Reported-by: Tobyn Bertram
> > Not-yet-signed-off-by: Takashi Iwai <tiwai@suse.de>
> > Not-yet-signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> > Not-yet-signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> You can keep my SOB.

Great, thanks.
 
> > +static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
> > +{
> > +	input_mt_slot(dev, slot);
> > +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
> > +	if (active) {
> > +		input_report_abs(dev, ABS_MT_POSITION_X, x);
> > +		input_report_abs(dev, ABS_MT_POSITION_Y,
> > +				 YMAX_NOMINAL + YMIN_NOMINAL - y);
> > +	}
> > +}
> 
> I take it that you feel MT_TOOL_FINGER should always be set, even if
> it's always the same as BTN_TOOL_*? I just want to be sure this is
> intended so we document it appropriately.

Yes - the MT_TOOLs are only emitted when explicitly set in absbit, but
the internal interface always handles it. This is actually documented
in the code (and DocBook).

> 
> > @@ -623,6 +686,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
> >  	int i;
> >  
> >  	__set_bit(INPUT_PROP_POINTER, dev->propbit);
> > +	__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
> 
> Shouldn't this only be set when SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) is
> true?

Indeed - thanks.

Henrik
