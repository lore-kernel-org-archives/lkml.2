Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0KSRCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:02:43 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:38156 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0KSRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IElzS3Riz8LwwepSvVJ7ls2GpBJwDmqtF/rTVY0lE5dCGF4hSAcpoyX9Ov8TNTY9b0
         HZBydNo3TUgAvyCA71YOxsy8elBATY4jcbxc4CVCrGVCQskk0Ed7tX0OQ0EtLfYSbZQ/
         IdtsDNS67E9rqFhpY+N4ZzDrytmSkKgiA8a+4=
Date: Fri, 19 Nov 2010 09:02:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Subject: Re: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons,
 switches and LEDs
Message-ID: <20101119170232.GB6236@core.coreip.homeip.net>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
 <cover.1289935504.git.bengardiner@nanometrics.ca>
 <d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
 <B85A65D85D7EB246BE421B3FB0FBB59302477EAA89@dbde02.ent.ti.com>
 <AANLkTike4sRvptEe9PXLT2u+SrFMOpNC6pvLPSzBfVOX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTike4sRvptEe9PXLT2u+SrFMOpNC6pvLPSzBfVOX@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, Nov 19, 2010 at 10:40:50AM -0500, Ben Gardiner wrote:
> 
> >> +
> >> +static struct gpio_keys_platform_data user_sw_gpio_key_platform_data = {
> >> +     .buttons = user_sw_gpio_keys,
> >> +     .nbuttons = ARRAY_SIZE(user_sw_gpio_keys),
> >> +     .rep = 0, /* disable auto-repeat */
> >> +     .poll_interval = DA850_SW_POLL_MS,
> >> +};
> >
> > I wonder if we really have create to separate platform data
> > for switches and push buttons. If it is only the debounce period
> > that is different, it can be handled by initializing that field
> > differently.
> 
> I see. Good idea; we can declare an array of gpio_keys_platform_data.
> 
> Note; it is the polling interval which differs, not the debounce interval.

Another question is why do you want to poll the same device at
different intervals? The processor is already woken up so it makes sense
to do as much as possible instead of going to sleep. In your case
200/700 for every 1400ms interval you wake an extra time to poll
switches so unless polling switches takes very long time it is better to
combine them together (and into one input device, probably).

-- 
Dmitry
