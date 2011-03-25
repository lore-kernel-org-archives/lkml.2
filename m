Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1CYS6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:58:38 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43488 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1CYS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:58:36 -0400
Date: Fri, 25 Mar 2011 13:58:24 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        vojtech@suze.cz
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110325185824.GE14328@thinkpad-t410>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Corentin Chary <corentin.chary@gmail.com>,
	Chris Bagwell <chris@cnpbagwell.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	vojtech@suze.cz
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
 <20110325161405.GC5099@core.coreip.homeip.net>
 <20110325162850.GD14328@thinkpad-t410>
 <20110325170333.GD5099@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325170333.GD5099@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 10:03:33AM -0700, Dmitry Torokhov wrote:
> > So, would the following make sense (KEY_TBD is may abbreviation for "key
> > to be determinded"):
> > 
> >  - On press (0xe4), send KEY_TBD, value = 1
> >  - On hold (0xea), send KEY_TBD, value = 2
> >  - On release (0xe5), send KEY_TBD, value = 0
> 
> Yes.

There's a little problem with this. The driver uses sparse-keymap, which
calls input_report_key(), which is doing this:

	input_event(dev, EV_KEY, code, !!value);

I don't see the hold events in userspace, so they must be getting
dropped as duplicates as you suggested.

I'm not sure who is at fault here. Should input_report_key() not be
forcing value to 0 or 1? Or should sparse-keymap be calling
input_event() directly? Or is sparse-keymap the wrong tool for handling
keys this way?

Thanks,
Seth

