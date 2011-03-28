Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1C1NqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:46:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40051 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab1C1NqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:46:17 -0400
Date: Mon, 28 Mar 2011 08:46:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        vojtech@suze.cz
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110328134606.GA16374@thinkpad-t410>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Corentin Chary <corentin.chary@gmail.com>,
	Chris Bagwell <chris@cnpbagwell.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	vojtech@suze.cz
References: <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
 <20110325161405.GC5099@core.coreip.homeip.net>
 <20110325162850.GD14328@thinkpad-t410>
 <20110325170333.GD5099@core.coreip.homeip.net>
 <20110325185824.GE14328@thinkpad-t410>
 <20110327171304.GD30244@core.coreip.homeip.net>
 <AANLkTikBnAdXHR4iqzq9Zd6D-OYe4yp-zELPh6iLr6sj@mail.gmail.com>
 <20110327191116.GB31692@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110327191116.GB31692@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 12:11:16PM -0700, Dmitry Torokhov wrote:
> > If we do set up auto-repeat and increase REP_DELAY, I'm guessing this
> > would enable auto-repeat for all other keys defined in driver?  That
> > needs to have some thought on if could have negative impact (any other
> > keys not using auto-release?).
> 
> Right. Right now there are 4 autoreprat options (in general):
> 
> - hardware autorepeat (if hardware supports it);
> - input core software autorepeat (one delay and rate per input device);
> - driver-implemented software autorepeat - in cases when different
>   repeat rate is needed;
> - userspace autorepeat (like X does nowadays);
> 
> Well, 4th option is not mutually exclusive with the other 3...

Currently all the other keys are using autorelease, so the autorepeat
setting shouldn't be affecting them at all. So the concern is whether
enabling autorepeat could become a problem the next time some oddball
key shows up on a machine.

Corentin, you were concerned about the loss of information to userspace,
but it seems the only way to maintain the hardware events is to drop the
use of sparse-keymap altogether. Do you have an opinion on how to
proceed?

I'm leaning towards using the input core autorepeat, since it seems to
get the closest to typical key behavior.

Seth

