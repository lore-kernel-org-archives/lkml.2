Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2KTV2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:28:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2KTV2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:28:46 -0500
Message-ID: <1353446929.28318.43.camel@fourier>
Subject: Re: [PATCH 2/2] input: Cypress PS/2 Trackpad link into psmouse-base
From: Kamal Mostafa <kamal@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        Dudley Du <dudl@cypress.com>
Date: Tue, 20 Nov 2012 13:28:49 -0800
In-Reply-To: <20121119234801.GB21922@core.coreip.homeip.net>
References: <1353367837-18229-1-git-send-email-kamal@canonical.com>
	 <1353367837-18229-3-git-send-email-kamal@canonical.com>
	 <20121119234801.GB21922@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 15:48 -0800, Dmitry Torokhov wrote:
> Hi Kamal,
> 
> On Mon, Nov 19, 2012 at 03:30:37PM -0800, Kamal Mostafa wrote:
> > @@ -321,6 +323,13 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
> >  	if (psmouse->state <= PSMOUSE_RESYNCING)
> >  		goto out;
> >  
> > +	/* For Cypress Trackpad to read some special data more than 6 bytes. */
> > +	if (psmouse->state == PSMOUSE_CMD_CYTP) {
> > +		psmouse->packet[psmouse->pktcnt++] = data;
> > +		wake_up(&psmouse->ps2dev.wait);
> > +		goto out;
> > +	}
> 
> Instead of doing this have you tried extending size of cmdbuf in ps2dev
> structure to 8?
> 

Thanks for suggesting this Dmitry.  I have now done that (and modified
cypress_ps2.c to set psmouse->state to the common PSMOUSE_CMD_MODE
instead).  This makes the psmouse-base linkage entirely clean, I
think...

And it *almost* works!  (Multitouch no longer works after suspend now).

Please see the forthcoming [PATCH v2] set, and thanks again for your
help.

 -Kamal


