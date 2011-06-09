Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab1FIMHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:07:36 -0400
Received: from mail001.aei.ca ([206.123.6.130]:37153 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1FIMHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:07:32 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Linux 2.6.39.1
Date: Thu, 9 Jun 2011 08:07:26 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39.1-crc+; KDE/4.6.3; x86_64; ; )
Cc: Chase Douglas <chase.douglas@canonical.com>, Greg KH <gregkh@suse.de>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110603003835.GA20381@kroah.com> <4DEF9705.4070502@canonical.com> <alpine.LNX.2.00.1106081740040.22872@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1106081740040.22872@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090807.27459.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 June 2011 11:41:03 Jiri Kosina wrote:
> On Wed, 8 Jun 2011, Chase Douglas wrote:
> 
> > > I also played a bit with 1.1 CSR dongle and couldn't find any mask that would
> > > be accepted. I think this command can be left out for older than 1.2 devices.
> > > 
> > > Following patch should do it. Could you verify it. I don't have access to old
> > > hw ATM.
> > > 
> > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > index 19cd4af..86d1e26 100644
> > > --- a/net/bluetooth/hci_event.c
> > > +++ b/net/bluetooth/hci_event.c
> > > @@ -477,14 +477,16 @@ static void hci_setup_event_mask(struct hci_dev *hdev)
> > >          * command otherwise */
> > >         u8 events[8] = { 0xff, 0xff, 0xfb, 0xff, 0x00, 0x00, 0x00, 0x00 };
> > >  
> > > -       /* Events for 1.2 and newer controllers */
> > > -       if (hdev->lmp_ver > 1) {
> > > -               events[4] |= 0x01; /* Flow Specification Complete */
> > > -               events[4] |= 0x02; /* Inquiry Result with RSSI */
> > > -               events[4] |= 0x04; /* Read Remote Extended Features Complete */
> > > -               events[5] |= 0x08; /* Synchronous Connection Complete */
> > > -               events[5] |= 0x10; /* Synchronous Connection Changed */
> > > -       }
> > > +       /* CSR 1.1 dongles does not accept any bitfield so don't try to set
> > > +        * any event mask for pre 1.2 devices */
> > > +       if (hdev->lmp_ver <= 1)
> > > +               return;
> > > +
> > > +       events[4] |= 0x01; /* Flow Specification Complete */
> > > +       events[4] |= 0x02; /* Inquiry Result with RSSI */
> > > +       events[4] |= 0x04; /* Read Remote Extended Features Complete */
> > > +       events[5] |= 0x08; /* Synchronous Connection Complete */
> > > +       events[5] |= 0x10; /* Synchronous Connection Changed */
> > >  
> > >         if (hdev->features[3] & LMP_RSSI_INQ)
> > >                 events[4] |= 0x04; /* Inquiry Result with RSSI */
> > 
> > Where did this patch come from? I don't see it in Linus' tree. If this
> > patch is merged, I can test the a new kernel out to see if we should
> > back out the commit from Jiri. However, right now my magic trackpad
> > (which has the same issue as the magic mouse) works fine on plain 2.6.39.1.
> 
> It might be because of different versions of CSR dongles you guys might 
> have.
> 
> I am still a bit lost here -- Ed, do you say that with the patch above, 
> and with my patch reverted, your device is working properly?

Yes.  Your understanding is correct.

Thanks,
Ed
