Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2LCREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:04:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34581 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2LCREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:04:36 -0500
Date: Mon, 3 Dec 2012 09:04:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Kamal Mostafa <kamal@canonical.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>, Dudley Du <dudl@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH v3 2/4] input: Cypress PS/2 Trackpad psmouse driver
Message-ID: <20121203170420.GD28682@core.coreip.homeip.net>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
 <1354226281-3476-3-git-send-email-kamal@canonical.com>
 <20121203074520.GA2687@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203074520.GA2687@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 08:45:20AM +0100, Henrik Rydberg wrote:
> > +/*
> > + * reset trackpad device to standard relative mode.
> > + * This is also the defalut mode when trackpad powered on.
> > + */
> > +static void cypress_reset(struct psmouse *psmouse)
> > +{
> > +	struct cytp_data *cytp = psmouse->private;
> > +
> > +	psmouse_reset(psmouse);
> > +
> > +	CYTP_SET_MODE_BIT(CYTP_BIT_STANDARD_REL);
> > +	CYTP_SET_PACKET_SIZE(3);
> > +
> > +	cytp->prev_contact_cnt = 0;
> > +}
> 
> I suppose it is, but is it necessary to reset to default mode?

It most likely is, as quite a few BIOSes get very upset and refuse to
shutdown/suspend/resume if they find mouse (touchpad) in state other
than bog-standard PS/2 mode. So psmouse_reset() is needed, the rest is
not so much as the device supposed to be inactive from this point on.

Thanks.

-- 
Dmitry
