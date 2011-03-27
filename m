Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1C0TLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 15:11:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37164 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1C0TLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 15:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Eh+1dFSBhjcYXBFul/tEJa4X+e1k25q1o66oiBk0Nqjb9ScHpyDobXR54tXx0OFBLF
         552w0TuvEgkjHoFsmUjIktYfs3pZb6lq7jELR8+E981GSExVNPjXO45H4M2Yh6baBpxL
         WRzOF5b25Bp+jKHRGzVO6T/L3VE5b9GEfEzJs=
Date: Sun, 27 Mar 2011 12:11:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        vojtech@suze.cz
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110327191116.GB31692@core.coreip.homeip.net>
References: <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
 <20110325161405.GC5099@core.coreip.homeip.net>
 <20110325162850.GD14328@thinkpad-t410>
 <20110325170333.GD5099@core.coreip.homeip.net>
 <20110325185824.GE14328@thinkpad-t410>
 <20110327171304.GD30244@core.coreip.homeip.net>
 <AANLkTikBnAdXHR4iqzq9Zd6D-OYe4yp-zELPh6iLr6sj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikBnAdXHR4iqzq9Zd6D-OYe4yp-zELPh6iLr6sj@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 01:32:45PM -0500, Chris Bagwell wrote:
> On Sun, Mar 27, 2011 at 12:13 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Fri, Mar 25, 2011 at 01:58:24PM -0500, Seth Forshee wrote:
> >> On Fri, Mar 25, 2011 at 10:03:33AM -0700, Dmitry Torokhov wrote:
> >> > > So, would the following make sense (KEY_TBD is may abbreviation for "key
> >> > > to be determinded"):
> >> > >
> >> > >  - On press (0xe4), send KEY_TBD, value = 1
> >> > >  - On hold (0xea), send KEY_TBD, value = 2
> >> > >  - On release (0xe5), send KEY_TBD, value = 0
> >> >
> >> > Yes.
> >>
> >> There's a little problem with this. The driver uses sparse-keymap, which
> >> calls input_report_key(), which is doing this:
> >>
> >>       input_event(dev, EV_KEY, code, !!value);
> >
> > Ah, right, it really did not have in mind passing on auto-repeating keys
> > as is when it was written.
> >
> >>
> >> I don't see the hold events in userspace, so they must be getting
> >> dropped as duplicates as you suggested.
> >>
> >> I'm not sure who is at fault here. Should input_report_key() not be
> >> forcing value to 0 or 1? Or should sparse-keymap be calling
> >> input_event() directly? Or is sparse-keymap the wrong tool for handling
> >> keys this way?
> >
> > I do not thik we shoudl burden sparse-keymap with handling repeats. Just
> > mark the device as auto-repeating (by setting EV_REP bit) and let input
> > core autorepeat logic do it for you.
> 
> It would be nice to have this key sent roughly every 2 seconds to
> re-execute a rotate script using generic key-to-script support in most
> X environments.  So to use kernel auto-repeat we'd need to bump up
> REP_DELAY quite a bit or do filtering in userspace.  If userspace is
> filtering then its not much more work to do their own auto-repeat as
> well.

That is true as well.

> 
> If we do set up auto-repeat and increase REP_DELAY, I'm guessing this
> would enable auto-repeat for all other keys defined in driver?  That
> needs to have some thought on if could have negative impact (any other
> keys not using auto-release?).

Right. Right now there are 4 autoreprat options (in general):

- hardware autorepeat (if hardware supports it);
- input core software autorepeat (one delay and rate per input device);
- driver-implemented software autorepeat - in cases when different
  repeat rate is needed;
- userspace autorepeat (like X does nowadays);

Well, 4th option is not mutually exclusive with the other 3...

-- 
Dmitry
