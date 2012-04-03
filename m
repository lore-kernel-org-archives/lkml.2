Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2DCNGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:06:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2DCNGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:06:41 -0400
Date: Tue, 3 Apr 2012 06:06:36 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/5] hid: Parse the device before adding it
In-Reply-To: <CAN+gG=G9KSjSFmWpxpPLzMzz14ePAhQKTJZjQBsPeq2iztZ17A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204030603550.9041@pobox.suse.cz>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se> <1333436730-13008-4-git-send-email-rydberg@euromail.se> <CAN+gG=G9KSjSFmWpxpPLzMzz14ePAhQKTJZjQBsPeq2iztZ17A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Benjamin Tissoires wrote:

> > The hid bus is populated by devices created by the usb and bluetooth
> > subsystems. The hid device is then broadcast to userland via uevents.
> > Currently, the parsing of the hid reports is done during probe of
> > the hid device, after the device has been broadcast. In order to
> > allow for the report descriptors to influence the device properties,
> > it is desirable to parse the device _before_ it is broadcast to
> > userland. In actuality, the parsing depends only accidentally on
> > the driver being present, so it can be trivially achieved.
> >
> > Something also needs to be done for the report_fixup handler, which
> > seems to be the only hard device-driver coupling in the code.
> >
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> >  drivers/hid/hid-core.c        |    2 +-
> >  drivers/hid/usbhid/hid-core.c |    5 +++++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 35ba9d9..8a7b59e 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -658,7 +658,7 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
> >                hid_parser_reserved
> >        };
> >
> > -       if (device->driver->report_fixup)
> > +       if (device->driver && device->driver->report_fixup)
> >                start = device->driver->report_fixup(device, start, &size);
> 
> Well, this is not a good solution for the following drivers:
> hid-zydacron
> hid-prodikeys
> hid-uclogic
> hid-samsung
> hid-sony, etc...
> 
> they all use report_fixup and as the parse is made only once, they
> won't be able to work properly.

For completness -- please see a discussion that's a little bit related to 
this (and namely the patch I have proposed yesterday) here:

	http://www.spinics.net/lists/linux-input/msg20061.html

-- 
Jiri Kosina
SUSE Labs
