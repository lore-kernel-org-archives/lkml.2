Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1EYRE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:04:28 -0400
Received: from relay02.telecomputing.no ([217.173.253.102]:56917 "EHLO
	relay02.telecomputing.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab1EYREZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:04:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG013U3ZrfjG/2dsb2JhbACmLHjFYoYcBJUDijU
X-IronPort-AV: E=Sophos;i="4.65,268,1304287200"; 
   d="scan'208";a="135151566"
From: "Cufi, Carles" <carles.cufi@nordicsemi.no>
To: "wyrles@ytram.com" <wyrles@ytram.com>,
        "corey@kansanian.com" <corey@kansanian.com>
CC: "'Ed Tomlinson'" <edt@aei.ca>, "'Ville Tervo'" <ville.tervo@nokia.com>,
        "'Bluettooth Linux'" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 19:04:21 +0200
Subject: RE: Linux 2.6.39
Thread-Topic: Linux 2.6.39
Thread-Index: AQGUKt7R/T/916P1fB9/N50PhgUuCwGLqzLiAU0RkDMBZ9ryawGkHAjPAqaiMpsCHZd2SJS4UodggAAGfzA=
Message-ID: <5B4B9A479BF6994B88EA975675EC5B79057A6029C4@MES1OS2SXC003.mes1.tconet.net>
References: <BANLkTinG_qCtHQYRYFQUJ9oGv4H1cuznWg@mail.gmail.com>
 <201105250711.17971.edt@aei.ca>	<20110525113614.GQ2480@null>
 <201105250812.43246.edt@aei.ca>
 <5B4B9A479BF6994B88EA975675EC5B79057A399D82@MES1OS2SXC003.mes1.tconet.net>
 <BANLkTi=ec3bh24=2r8f3tmj2g0n0bMnq1Q@mail.gmail.com>
 <5B4B9A479BF6994B88EA975675EC5B79057A60296D@MES1OS2SXC003.mes1.tconet.net>
 <013c01cc1af9$361b00e0$a25102a0$@ytram.com>
In-Reply-To: <013c01cc1af9$361b00e0$a25102a0$@ytram.com>
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

 (Snipping...)
On Wed, May 25, 2011 at 8:46 AM, Cufi, Carles <carles.cufi@nordicsemi.no>
wrote:
> On Wednesday 25 May 2011 07:36:14 Ville Tervo wrote:
>> On Wed, May 25, 2011 at 07:11:17AM -0400, ext Ed Tomlinson wrote:
>> > On Wednesday 25 May 2011 06:54:54 Corey Boyle wrote:
>> > > > On Mon, May 23, 2011 at 06:08:36PM -0400, ext Ed Tomlinson wrote:
>> > > > > On Saturday 21 May 2011 16:31:00 Ed Tomlinson wrote:
>> > > > > > On Saturday 21 May 2011 13:56:20 Milan Oravec wrote:
...
>> > Read Local Version Information (0x04|0x0001) plen 0
>> > > HCI Event: Command Complete (0x0e) plen 12
>> >     Read Local Version Information (0x04|0x0001) ncmd 1
>> >     status 0x00
>> >     HCI Version: 1.1 (0x1) HCI Revision: 0x20d
*************************
>> >     LMP Version: 1.1 (0x1) LMP Subversion: 0x20d
*************************
>> >     Manufacturer: Cambridge Silicon Radio (10) < HCI Command: Set 
>> > Event Mask (0x03|0x0001) plen 8
>> >     Mask: 0xfffffbff00000000
*************************
>> > > HCI Event: Command Complete (0x0e) plen 4
>> >     Set Event Mask (0x03|0x0001) ncmd 1
>> >     status 0x12
>> >     Error: Invalid HCI Command Parameters
>
>Set Event Mask has been in the Bluetooth Spec since day 1, so it must 
>be
>the bitmask, which has been extended with each new spec release to cover newly >added events. Looking at the latest spec, and judging >by the year your chipset was released in (it probably is a 1.1 compliant chipset) I believe that >0x000000008FFFFFFF is the highest >event mask it would support (up until and including Page Scan Repetition Mode Change Event), but since I don't have the >old 1.1 spec >around I may be one or two bits off.

>The device appears to have identified itself as CSR firmware using Bluetooth version 1.1.
>I do happen to have the 1.1 spec lying around :-), for Set_Event_Mask it says
>0x0000000100000000
>To                                          Reserved for future use
>0x8000000000000000
>0x00000000FFFFFFFF	Default (All events enabled)
>The mask above looks ok (no undefined bits), but are they supposed to be displayed in that order? (IOW, are the bytes in correct >order?)

The HCI spec lists this as a 64-bit number but it must be sent in Little Endian to the controller, hence the reverse order in Ville Tervo's patch earlier in the email thread. 

Carles

