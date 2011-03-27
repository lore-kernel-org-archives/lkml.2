Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1C0Scs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 14:32:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62511 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1C0Scr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 14:32:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110327171304.GD30244@core.coreip.homeip.net>
References: <20110324195720.GB31713@thinkpad-t410>
	<1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
	<AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
	<20110325135311.GA14328@thinkpad-t410>
	<AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
	<20110325161405.GC5099@core.coreip.homeip.net>
	<20110325162850.GD14328@thinkpad-t410>
	<20110325170333.GD5099@core.coreip.homeip.net>
	<20110325185824.GE14328@thinkpad-t410>
	<20110327171304.GD30244@core.coreip.homeip.net>
Date: Sun, 27 Mar 2011 13:32:45 -0500
Message-ID: <AANLkTikBnAdXHR4iqzq9Zd6D-OYe4yp-zELPh6iLr6sj@mail.gmail.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate key
From: Chris Bagwell <chris@cnpbagwell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        vojtech@suze.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 12:13 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Mar 25, 2011 at 01:58:24PM -0500, Seth Forshee wrote:
>> On Fri, Mar 25, 2011 at 10:03:33AM -0700, Dmitry Torokhov wrote:
>> > > So, would the following make sense (KEY_TBD is may abbreviation for "key
>> > > to be determinded"):
>> > >
>> > >  - On press (0xe4), send KEY_TBD, value = 1
>> > >  - On hold (0xea), send KEY_TBD, value = 2
>> > >  - On release (0xe5), send KEY_TBD, value = 0
>> >
>> > Yes.
>>
>> There's a little problem with this. The driver uses sparse-keymap, which
>> calls input_report_key(), which is doing this:
>>
>>       input_event(dev, EV_KEY, code, !!value);
>
> Ah, right, it really did not have in mind passing on auto-repeating keys
> as is when it was written.
>
>>
>> I don't see the hold events in userspace, so they must be getting
>> dropped as duplicates as you suggested.
>>
>> I'm not sure who is at fault here. Should input_report_key() not be
>> forcing value to 0 or 1? Or should sparse-keymap be calling
>> input_event() directly? Or is sparse-keymap the wrong tool for handling
>> keys this way?
>
> I do not thik we shoudl burden sparse-keymap with handling repeats. Just
> mark the device as auto-repeating (by setting EV_REP bit) and let input
> core autorepeat logic do it for you.

It would be nice to have this key sent roughly every 2 seconds to
re-execute a rotate script using generic key-to-script support in most
X environments.  So to use kernel auto-repeat we'd need to bump up
REP_DELAY quite a bit or do filtering in userspace.  If userspace is
filtering then its not much more work to do their own auto-repeat as
well.

If we do set up auto-repeat and increase REP_DELAY, I'm guessing this
would enable auto-repeat for all other keys defined in driver?  That
needs to have some thought on if could have negative impact (any other
keys not using auto-release?).

Chris

>
> Thanks.
>
> --
> Dmitry
>
