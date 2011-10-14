Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1JNALZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 20:11:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1JNALX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 20:11:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=U3SLCfEVgw4FlHD8ddRjIARdjvesB2v0dtRBqPW6bIC2+tGJ6w3oHrOfgCmLvjS4B
	NyuHLi7Au8CXAKs2sjRuQ==
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110140134200.14768@pobox.suse.cz>
References: <1318548517-5289-1-git-send-email-tlambert@chromium.org>
	<alpine.LNX.2.00.1110140134200.14768@pobox.suse.cz>
Date: Thu, 13 Oct 2011 17:11:20 -0700
X-Google-Sender-Auth: OnGFgXCkLPbUsRvlQfNBGohjLF0
Message-ID: <CAA_E9NHi4mS+J5VrxS915S3TD-157D=hMG7b-PMT2c1RYvnwVQ@mail.gmail.com>
Subject: Re: [PATCH] Driver for Primax keyboards violating USB HID spec
From: Terry Lambert <tlambert@chromium.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri; thanks for looking so promptly!

The routine right now just caches the hi->input for later look up
during the raw input report, which I suppose could be done inline on
each report with a couple function calls.

The reasoning was that there's some  hardware that's going to fall
into this class that needs some key remapping done.  Maybe this
hardware, too, depending on what is decided about the num lock not
being on by default for a newly plugged keyboard (this specific
keyboard has no num lock key).

I don't have one of the folding keyboards people are complaining about
not being able to use for Android tablets on hand, or the unhappy Dell
Inspiron laptop, both of which use the controller   That's to explain
why the remapping code and the product ID for them are missing from
this patch.

If it would make things easier, I could inline the input lookup and
just ditch the routine altogether, until I or someone else gets their
hands on the other hardware.

Thanks,
-- Terry

On Thu, Oct 13, 2011 at 4:35 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> On Thu, 13 Oct 2011, Terry Lambert wrote:
>
> > Primax keyboards with the issue this driver addresses report modifier
> > keys as in band key events instead of as out of band modifier bits,
> > resulting in the modifier keys generating key up events immediately
> > before the keys they are intended to modify.  This driver rewrites
> > the raw report data from such keyboards into USB HID 1.11 compliant
> > report data.  It only matches the USB vendor and product IDs for the
> > keyboard it has been tested on. Since there are several keyboards,
> > notably a number of laptops and folding USB keyboards known to have
> > similar unresolved problem reports, the list is expected to grow.
> >
> > Signed-off-by: Terry Lambert <tlambert@chromium.org>
>
> Terry,
>
> thanks for the patch.
>
> [ ... snip ... ]
> > +static int px_input_mapping(struct hid_device *hid, struct hid_input *hi,
> > +     struct hid_field *field, struct hid_usage *usage,
> > +     unsigned long **bit, int *max)
> > +{
> > +     struct px_device *px = hid_get_drvdata(hid);
> > +
> > +     px->input_primax = hi->input;
> > +
> > +     /* Remap keys, if necesssary, here */
> > +
> > +     return 0;
> > +}
>
> I fail to see the point of this routine ... ?
>
> Otherwise, the patch seems fine.
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
