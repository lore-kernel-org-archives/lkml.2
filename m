Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1EZKsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:48:02 -0400
Received: from mail001.aei.ca ([206.123.6.130]:40349 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011Ab1EZKsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:48:00 -0400
From: Ed Tomlinson <edt@aei.ca>
To: corey@kansanian.com
Subject: Re: Linux 2.6.39
Date: Thu, 26 May 2011 06:47:55 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39-crc+; KDE/4.6.3; x86_64; ; )
Cc: Ville Tervo <ville.tervo@nokia.com>, wyrles@ytram.com,
        "Cufi, Carles" <carles.cufi@nordicsemi.no>,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <BANLkTinG_qCtHQYRYFQUJ9oGv4H1cuznWg@mail.gmail.com> <20110526083746.GT2480@null> <BANLkTi=473CVADx9D-5m6jjvDjZGWMu3BA@mail.gmail.com>
In-Reply-To: <BANLkTi=473CVADx9D-5m6jjvDjZGWMu3BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105260647.55949.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011 06:17:20 Corey Boyle wrote:
> On Thu, May 26, 2011 at 4:37 AM, Ville Tervo <ville.tervo@nokia.com> wrote:
> > On Wed, May 25, 2011 at 09:11:19PM -0400, ext Corey Boyle wrote:
> >> On Wed, May 25, 2011 at 12:31 PM, Tom Allebrandi <wyrles@ytram.com> wrote:
> >> > -----Original Message-----
> >> > From: linux-bluetooth-owner@vger.kernel.org
> >> > [mailto:linux-bluetooth-owner@vger.kernel.org] On Behalf Of Cufi, Carles
> >> > Sent: Wednesday, May 25, 2011 7:15 AM
> >> > To: corey@kansanian.com
> >> > Cc: Ed Tomlinson; Ville Tervo; Bluettooth Linux;
> >> > linux-kernel@vger.kernel.org
> >> > Subject: RE: Linux 2.6.39
> >> >
> >> > (Snipping...)
> >> > On Wed, May 25, 2011 at 8:46 AM, Cufi, Carles <carles.cufi@nordicsemi.no>
> >> > wrote:
> >> >> On Wednesday 25 May 2011 07:36:14 Ville Tervo wrote:
> >> >>> On Wed, May 25, 2011 at 07:11:17AM -0400, ext Ed Tomlinson wrote:
> >> >>> > On Wednesday 25 May 2011 06:54:54 Corey Boyle wrote:
> >> >>> > > > On Mon, May 23, 2011 at 06:08:36PM -0400, ext Ed Tomlinson wrote:
> >> >>> > > > > On Saturday 21 May 2011 16:31:00 Ed Tomlinson wrote:
> >> >>> > > > > > On Saturday 21 May 2011 13:56:20 Milan Oravec wrote:
> >> > ...
> >> >>> > Read Local Version Information (0x04|0x0001) plen 0
> >> >>> > > HCI Event: Command Complete (0x0e) plen 12
> >> >>> >     Read Local Version Information (0x04|0x0001) ncmd 1
> >> >>> >     status 0x00
> >> >>> >     HCI Version: 1.1 (0x1) HCI Revision: 0x20d
> >> > *************************
> >> >>> >     LMP Version: 1.1 (0x1) LMP Subversion: 0x20d
> >> > *************************
> >> >>> >     Manufacturer: Cambridge Silicon Radio (10) < HCI Command: Set
> >> >>> > Event Mask (0x03|0x0001) plen 8
> >> >>> >     Mask: 0xfffffbff00000000
> >> > *************************
> >> >>> > > HCI Event: Command Complete (0x0e) plen 4
> >> >>> >     Set Event Mask (0x03|0x0001) ncmd 1
> >> >>> >     status 0x12
> >> >>> >     Error: Invalid HCI Command Parameters
> >> >>
> >> >>Set Event Mask has been in the Bluetooth Spec since day 1, so it must be
> >> > the bitmask, which has been extended with each new spec release to cover
> >> > newly >added events. Looking at the latest spec, and judging by the year
> >> > your chipset was released in (it probably is a 1.1 compliant chipset) I
> >> > believe that >0x000000008FFFFFFF is the highest event mask it would support
> >> > (up until and including Page Scan Repetition Mode Change Event), but since I
> >> > don't have the >old 1.1 spec around I may be one or two bits off.
> >> >
> >> > The device appears to have identified itself as CSR firmware using Bluetooth
> >> > version 1.1.
> >> >
> >> > I do happen to have the 1.1 spec lying around :-), for Set_Event_Mask it
> >> > says
> >> >
> >> > 0x0000000100000000
> >> > To                                          Reserved for future use
> >> > 0x8000000000000000
> >> >
> >> > 0x00000000FFFFFFFF      Default (All events enabled)
> >> >
> >>
> >> I am beginning to think that my adapter simply does not support this
> >> command.  I have tried with all the suggested bitmasks, all zeros, all
> >> ones, all combinations where a single bit is set, etc.  I'm not sure
> >> where to go from here other than add a flag which incidates that
> >> certain devices don't support this command so it can be skipped.
> >> Again, the only way I have gotten it to work is by not sending the
> >> command at all.  Thoughts?
> >
> > I also played a bit with 1.1 CSR dongle and couldn't find any mask that would
> > be accepted. I think this command can be left out for older than 1.2 devices.
> >
> > Following patch should do it. Could you verify it. I don't have access to old
> > hw ATM.
> >
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 19cd4af..86d1e26 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -477,14 +477,16 @@ static void hci_setup_event_mask(struct hci_dev *hdev)
> >         * command otherwise */
> >        u8 events[8] = { 0xff, 0xff, 0xfb, 0xff, 0x00, 0x00, 0x00, 0x00 };
> >
> > -       /* Events for 1.2 and newer controllers */
> > -       if (hdev->lmp_ver > 1) {
> > -               events[4] |= 0x01; /* Flow Specification Complete */
> > -               events[4] |= 0x02; /* Inquiry Result with RSSI */
> > -               events[4] |= 0x04; /* Read Remote Extended Features Complete */
> > -               events[5] |= 0x08; /* Synchronous Connection Complete */
> > -               events[5] |= 0x10; /* Synchronous Connection Changed */
> > -       }
> > +       /* CSR 1.1 dongles does not accept any bitfield so don't try to set
> > +        * any event mask for pre 1.2 devices */
> > +       if (hdev->lmp_ver <= 1)
> > +               return;
> > +
> > +       events[4] |= 0x01; /* Flow Specification Complete */
> > +       events[4] |= 0x02; /* Inquiry Result with RSSI */
> > +       events[4] |= 0x04; /* Read Remote Extended Features Complete */
> > +       events[5] |= 0x08; /* Synchronous Connection Complete */
> > +       events[5] |= 0x10; /* Synchronous Connection Changed */
> >
> >        if (hdev->features[3] & LMP_RSSI_INQ)
> >                events[4] |= 0x04; /* Inquiry Result with RSSI */
> > --
> >
> >
> 
> Patch works great - typing this email from my bluetooth keyboard.

Works here too.

Thanks
Ed
