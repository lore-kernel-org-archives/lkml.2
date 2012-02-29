Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2B2RyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:54:06 -0500
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:56459 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab2B2RyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:54:03 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 231969BEE7
Date: Wed, 29 Feb 2012 18:54:02 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: "Joshua C." <joshuacov@googlemail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
In-Reply-To: <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1202291836120.12283@be10.lrz>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz>
 <4F4D1E6A.5000200@zytor.com> <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1442818780-1330538042=:12283"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1442818780-1330538042=:12283
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 29 Feb 2012, Joshua C. wrote:
> 2012/2/28 H. Peter Anvin <hpa@zytor.com>:
>> On 02/28/2012 10:32 AM, Bodo Eggert wrote:

>>> Asking the BIOS is as correct as querying the memory location (defined
>>> to have same result), but more expensive.
>>
>>
>> Not quite, in reality; it is more likely to work on systems which implem=
ent
>> various kinds of bypass schemes. =A0The key aspect of this, though, is t=
hat
>> this is done on a BIOS path and not by groping a memory location which m=
ay
>> not even be initialized on non-BIOS systems.

> I got the idea that we should somehow check the kbd_state and set the
> numlock accordingly but this is behind my capabilities. I tried
> several times to read those boot_params but I have no idea how to do
> it. Where are they stored, how to access them? Help anyone?

There are two bytes in the BIOS data area, one (0x417 + 0x418) containing=
=20
the settings that are supposed to be set and one that contains the values=
=20
sent to the keyboard most recently (0x496 + 0x497). Both values are=20
compared on each int16 call and the LED are set accordingly if the=20
corresponding bits differ.

You can change the LED states by setting the according byte and calling=20
any keyboard interrupt function, e.g. querying the availability of=20
characters in the buffer. I don't know about any other way to do the same=
=20
using only the BIOS.
--8323329-1442818780-1330538042=:12283--
