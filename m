Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1EYOPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:15:30 -0400
Received: from relay02.telecomputing.no ([217.173.253.102]:41945 "EHLO
	relay02.telecomputing.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab1EYOP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:15:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFAM0N3U3ZrfjH/2dsb2JhbACmKnAIxV6GHASVAoo1
X-IronPort-AV: E=Sophos;i="4.65,267,1304287200"; 
   d="scan'208";a="135131520"
From: "Cufi, Carles" <carles.cufi@nordicsemi.no>
To: "corey@kansanian.com" <corey@kansanian.com>
CC: Ed Tomlinson <edt@aei.ca>, Ville Tervo <ville.tervo@nokia.com>,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 16:15:24 +0200
Subject: RE: Linux 2.6.39
Thread-Topic: Linux 2.6.39
Thread-Index: Acwa5SAsBnyI48O2Sj2Cpl36VdmOLwAAEMlw
Message-ID: <5B4B9A479BF6994B88EA975675EC5B79057A60296D@MES1OS2SXC003.mes1.tconet.net>
References: <BANLkTinG_qCtHQYRYFQUJ9oGv4H1cuznWg@mail.gmail.com>
	<201105250711.17971.edt@aei.ca>	<20110525113614.GQ2480@null>
	<201105250812.43246.edt@aei.ca>
	<5B4B9A479BF6994B88EA975675EC5B79057A399D82@MES1OS2SXC003.mes1.tconet.net>
 <BANLkTi=ec3bh24=2r8f3tmj2g0n0bMnq1Q@mail.gmail.com>
In-Reply-To: <BANLkTi=ec3bh24=2r8f3tmj2g0n0bMnq1Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 8:46 AM, Cufi, Carles <carles.cufi@nordicsemi.no> wrote:
>
>
> On Wednesday 25 May 2011 07:36:14 Ville Tervo wrote:
>> On Wed, May 25, 2011 at 07:11:17AM -0400, ext Ed Tomlinson wrote:
>> > On Wednesday 25 May 2011 06:54:54 Corey Boyle wrote:
>> > > > On Mon, May 23, 2011 at 06:08:36PM -0400, ext Ed Tomlinson wrote:
>> > > > > On Saturday 21 May 2011 16:31:00 Ed Tomlinson wrote:
>> > > > > > On Saturday 21 May 2011 13:56:20 Milan Oravec wrote:
>> > > > > > > Hi Linus, I'm sorry bothering you, but my usb-bluetooth 
>> > > > > > > dongle stop working in
>> > > > > > > 2.6.39 kernel series.
>> > > > > > > I know it is nothing ground breaking but it is bug.
>> > > > > > > I'm using this hardware from 2.6.11 kernel series.
>> > > > > > > Details are included in this thread:
>> > > > > > >
>> > > > > > > https://lkml.org/lkml/2011/4/18/481
>> > > > > > >
>> > > > > > > I hope I'm doing nothing false writing this email.
>> > > > > >
>> > > > > > Same device, same problem here.
>> > > > > >
>> > > > > > You are not alone
>> > > > >
>> > > > > I had some time this afternood so I tried bisecting without 
>> > > > > much luck.  I ended up \ somewhere rc1 ish with a system that 
>> > > > > would paniced during boot.  Here is the bisect \ log incase it helps:
>> > > > > # bad: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 
>> > > > > 2.6.39 # good: [521cb40b0c44418a4fd36dc633f575813d59a43d] 
>> > > > > Linux
>> > > > > 2.6.38 git bisect start 'v2.6.39' 'v2.6.38' '--' 'drivers/bluetooth'
>> > > > > # bad: [7a6362800cb7d1d618a697a650c7aaed3eb39320] Merge \
>> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-
>> > > > > 2
>> > > > > .6 git bisect bad \
>> > > > > 7a6362800cb7d1d618a697a650c7aaed3eb39320 # bad: \ 
>> > > > > [0a0e9ae1bd788bc19adc4d4ae08c98b233697402] Merge branch 
>> > > > > 'master' of \
>> > > > > master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6 git 
>> > > > > bisect bad \
>> > > > > 0a0e9ae1bd788bc19adc4d4ae08c98b233697402 # skip: \ 
>> > > > > [03c2d0e89409b59c1ec9d9511533cedc0b7aaa69] Bluetooth: Use
>> > > > > usb_fill_int_urb() git \ bisect skip
>> > > > > 03c2d0e89409b59c1ec9d9511533cedc0b7aaa69 # skip: \ 
>> > > > > [7f4b2b04c88377af30c022f36c060190182850fb] Bluetooth: Make 
>> > > > > hci a child of the \ corresponding tty device. git bisect 
>> > > > > skip 7f4b2b04c88377af30c022f36c060190182850fb
>> > > > > # skip: [84f0e17f78471857104a20dfc57711409f68d7bf] Bluetooth:
>> > > > > ath3k: Avoid \ duplication of code git bisect skip 
>> > > > > 84f0e17f78471857104a20dfc57711409f68d7bf
>> > > > >
>> > > > > Ring any bells for anyone?
>> > > > >
>> > > > > Probably should open a regression bug for this too....
>> > > >
>> > > > I think this is regression with 
>> > > > d5859e22cd40b73164b3e5d8d5d796f96edcc6af
>> > > > commit. Probably the code tries to enable something that is not supported.
>> > > >
>> > > > Could you pastebin hcidump while doing hciconfig hci0 up?
>>
>> Some cutting done
>>
>> >
>> > hcidump
>> > HCI sniffer - Bluetooth packet analyzer ver 2.0 < HCI Command: Read 
>> > Local Supported Features (0x04|0x0003) plen 0
>> > > HCI Event: Command Complete (0x0e) plen 12
>> >     Read Local Supported Features (0x04|0x0003) ncmd 1
>> >     status 0x00
>> >     Features: 0xff 0xff 0x0f 0x00 0x00 0x00 0x00 0x00 < HCI Command:
>> > Read Local Version Information (0x04|0x0001) plen 0
>> > > HCI Event: Command Complete (0x0e) plen 12
>> >     Read Local Version Information (0x04|0x0001) ncmd 1
>> >     status 0x00
>> >     HCI Version: 1.1 (0x1) HCI Revision: 0x20d
>> >     LMP Version: 1.1 (0x1) LMP Subversion: 0x20d
>> >     Manufacturer: Cambridge Silicon Radio (10) < HCI Command: Set 
>> > Event Mask (0x03|0x0001) plen 8
>> >     Mask: 0xfffffbff00000000
>> > > HCI Event: Command Complete (0x0e) plen 4
>> >     Set Event Mask (0x03|0x0001) ncmd 1
>> >     status 0x12
>> >     Error: Invalid HCI Command Parameters
>> >
>>
>> Yes the HCI_OP_SET_EVENT_MASK cmd seems to be the source of problems.
>>
>> Maybe is rejects it because two reserved bits are being enabled. 
>> Could you try this patch?
>>
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c 
>> index 19cd4af..e483e30 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -475,7 +475,7 @@ static void hci_setup_event_mask(struct hci_dev 
>> *hdev)
>>         /* The second byte is 0xff instead of 0x9f (two reserved bits
>>          * disabled) since a Broadcom 1.2 dongle doesn't respond to 
>> the
>>          * command otherwise */
>> -       u8 events[8] = { 0xff, 0xff, 0xfb, 0xff, 0x00, 0x00, 0x00, 
>> 0x00 };
>> +       u8 events[8] = { 0xff, 0x9f, 0xfb, 0xff, 0x00, 0x00, 0x00,
>> + 0x00 };
>>
>>         /* Events for 1.2 and newer controllers */
>>         if (hdev->lmp_ver > 1) {
>
>> No luck here - same results.
>
> For what it's worth:
>
> With a (recent)CSR chipset, with 2.6.38 only Set Event Filter is used (with a 0 filter) and no Set Event Mask is sent at all. With Bluetooth-next, I get the following:
>
> < HCI Command: Set Event Mask (0x03|0x0001) plen 8
>    Mask: 0xfffffbff07f8bf3d
>> HCI Event: Command Complete (0x0e) plen 4
>    Set Event Mask (0x03|0x0001) ncmd 1
>    status 0x00
>
> So Set Event Mask actually seems to go through without any problems.
>
> Carles
>
>My adapter is from 2002 so I'm guessing it either doesn't support Set Event Mask at all, or is very sensitive about the values it >receives.

Set Event Mask has been in the Bluetooth Spec since day 1, so it must be the bitmask, which has been extended with each new spec release to cover newly added events. Looking at the latest spec, and judging by the year your chipset was released in (it probably is a 1.1 compliant chipset) I believe that 0x000000008FFFFFFF is the highest event mask it would support (up until and including Page Scan Repetition Mode Change Event), but since I don't have the old 1.1 spec around I may be one or two bits off.

Carles
