Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1FMR11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:27:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60373 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab1FMR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:27:25 -0400
Date: Mon, 13 Jun 2011 14:27:39 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ed Tomlinson <edt@aei.ca>,
        Greg KH <gregkh@suse.de>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.39.1
Message-ID: <20110613172739.GA2661@joana>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Chase Douglas <chase.douglas@canonical.com>,
	Ed Tomlinson <edt@aei.ca>, Greg KH <gregkh@suse.de>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110603003835.GA20381@kroah.com>
 <201106032236.41294.edt@aei.ca>
 <4DED20C6.1020701@canonical.com>
 <201106061926.14661.edt@aei.ca>
 <4DEF9705.4070502@canonical.com>
 <20110608180146.GB13036@joana>
 <alpine.LNX.2.00.1106130010360.22872@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106130010360.22872@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina <jkosina@suse.cz> [2011-06-13 00:11:04 +0200]:

> On Wed, 8 Jun 2011, Gustavo F. Padovan wrote:
> 
> > > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > > index 19cd4af..86d1e26 100644
> > > > --- a/net/bluetooth/hci_event.c
> > > > +++ b/net/bluetooth/hci_event.c
> > > > @@ -477,14 +477,16 @@ static void hci_setup_event_mask(struct hci_dev *hdev)
> > > >          * command otherwise */
> > > >         u8 events[8] = { 0xff, 0xff, 0xfb, 0xff, 0x00, 0x00, 0x00, 0x00 };
> > > >  
> > > > -       /* Events for 1.2 and newer controllers */
> > > > -       if (hdev->lmp_ver > 1) {
> > > > -               events[4] |= 0x01; /* Flow Specification Complete */
> > > > -               events[4] |= 0x02; /* Inquiry Result with RSSI */
> > > > -               events[4] |= 0x04; /* Read Remote Extended Features Complete */
> > > > -               events[5] |= 0x08; /* Synchronous Connection Complete */
> > > > -               events[5] |= 0x10; /* Synchronous Connection Changed */
> > > > -       }
> > > > +       /* CSR 1.1 dongles does not accept any bitfield so don't try to set
> > > > +        * any event mask for pre 1.2 devices */
> > > > +       if (hdev->lmp_ver <= 1)
> > > > +               return;
> > > > +
> > > > +       events[4] |= 0x01; /* Flow Specification Complete */
> > > > +       events[4] |= 0x02; /* Inquiry Result with RSSI */
> > > > +       events[4] |= 0x04; /* Read Remote Extended Features Complete */
> > > > +       events[5] |= 0x08; /* Synchronous Connection Complete */
> > > > +       events[5] |= 0x10; /* Synchronous Connection Changed */
> > > >  
> > > >         if (hdev->features[3] & LMP_RSSI_INQ)
> > > >                 events[4] |= 0x04; /* Inquiry Result with RSSI */
> > > 
> > > Where did this patch come from? I don't see it in Linus' tree. If this
> > > patch is merged, I can test the a new kernel out to see if we should
> > > back out the commit from Jiri. However, right now my magic trackpad
> > > (which has the same issue as the magic mouse) works fine on plain 2.6.39.1.
> > 
> > This patch is in my tree. It will be on its way to Linus' tree today.
> 
> Doesn't seem to be present in Linus' tree as of today. Has there been any 
> issue discovered in the meantime?

No, it is on wireless-2.6 right now. Then goes to net-2.6 and finally linus-2.6.

	Gustavo
