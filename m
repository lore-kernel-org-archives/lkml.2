Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2KSXsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:48:08 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47952 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2KSXsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:48:06 -0500
Date: Mon, 19 Nov 2012 15:48:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 2/2] input: Cypress PS/2 Trackpad link into psmouse-base
Message-ID: <20121119234801.GB21922@core.coreip.homeip.net>
References: <1353367837-18229-1-git-send-email-kamal@canonical.com>
 <1353367837-18229-3-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353367837-18229-3-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

On Mon, Nov 19, 2012 at 03:30:37PM -0800, Kamal Mostafa wrote:
> @@ -321,6 +323,13 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
>  	if (psmouse->state <= PSMOUSE_RESYNCING)
>  		goto out;
>  
> +	/* For Cypress Trackpad to read some special data more than 6 bytes. */
> +	if (psmouse->state == PSMOUSE_CMD_CYTP) {
> +		psmouse->packet[psmouse->pktcnt++] = data;
> +		wake_up(&psmouse->ps2dev.wait);
> +		goto out;
> +	}

Instead of doing this have you tried extending size of cmdbuf in ps2dev
structure to 8?

Thanks.

-- 
Dmitry
