Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424940Ab2LGCJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:09:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41370 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423613Ab2LGCJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:09:08 -0500
Message-ID: <1354846144.2795.76.camel@fourier>
Subject: Re: [PATCH v5 2/3] input: Cypress PS/2 Trackpad psmouse driver
From: Kamal Mostafa <kamal@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, Dudley Du <dudl@cypress.com>,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Date: Thu, 06 Dec 2012 18:09:04 -0800
In-Reply-To: <20121206080850.GC25921@core.coreip.homeip.net>
References: <1354752976-27257-1-git-send-email-kamal@canonical.com>
	 <1354752976-27257-3-git-send-email-kamal@canonical.com>
	 <20121206080850.GC25921@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 00:08 -0800, Dmitry Torokhov wrote:
> [...]


Hi Dmitry-

Thanks again for your review.  The forthcoming PATCH v6 addresses all of
your requests, except for:

> > +	__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
> 
> I do not think it should be marked INPUT_PROP_BUTTONPAD if it has
> physical buttons...

This device (my particular Cypress Trackpad unit anyway) does not have
physical buttons.  The pad is clickable; I think it is a standard
"buttonpad" device.



And just FYI, this issue has been addressed but to answer your question:

> > +
> > +	if (cytp->mode & CYTP_BIT_ABS_MASK) {
> 
> It can't be anything else, can it?

It can: in the case when the mode hasn't been set at all yet (during
detect and reconnect).  I cleaned up the logic of this routine
(cypress_validate_byte) and added explanatory comments.


 -Kamal


