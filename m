Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1C0RNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 13:13:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1C0RNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 13:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kY16hKnMem05ggOyiLBJwUItCwaKF7P8TZbQ5K7hE1O0hKctDew/Yf5itjZ+AzRaCm
         PXVA9ZAv1X0cE5L3TgiQ91zdEAA1UXO1rg4yp/8/y/BUtX9KhYRdESMfGfer2f7onAV/
         rsPaOhy4KaqAtaZpPjnHjvNIUOkyGV6phLdas=
Date: Sun, 27 Mar 2011 10:13:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        vojtech@suze.cz
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110327171304.GD30244@core.coreip.homeip.net>
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
 <20110325161405.GC5099@core.coreip.homeip.net>
 <20110325162850.GD14328@thinkpad-t410>
 <20110325170333.GD5099@core.coreip.homeip.net>
 <20110325185824.GE14328@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325185824.GE14328@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 01:58:24PM -0500, Seth Forshee wrote:
> On Fri, Mar 25, 2011 at 10:03:33AM -0700, Dmitry Torokhov wrote:
> > > So, would the following make sense (KEY_TBD is may abbreviation for "key
> > > to be determinded"):
> > > 
> > >  - On press (0xe4), send KEY_TBD, value = 1
> > >  - On hold (0xea), send KEY_TBD, value = 2
> > >  - On release (0xe5), send KEY_TBD, value = 0
> > 
> > Yes.
> 
> There's a little problem with this. The driver uses sparse-keymap, which
> calls input_report_key(), which is doing this:
> 
> 	input_event(dev, EV_KEY, code, !!value);

Ah, right, it really did not have in mind passing on auto-repeating keys
as is when it was written.

> 
> I don't see the hold events in userspace, so they must be getting
> dropped as duplicates as you suggested.
> 
> I'm not sure who is at fault here. Should input_report_key() not be
> forcing value to 0 or 1? Or should sparse-keymap be calling
> input_event() directly? Or is sparse-keymap the wrong tool for handling
> keys this way?

I do not thik we shoudl burden sparse-keymap with handling repeats. Just
mark the device as auto-repeating (by setting EV_REP bit) and let input
core autorepeat logic do it for you.

Thanks.

-- 
Dmitry
