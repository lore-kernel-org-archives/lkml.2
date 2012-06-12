Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2FLTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:09:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46430 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2FLTJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:09:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120612170412.359967ec@pyramind.ukuu.org.uk>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
	<CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
	<CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
	<CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
	<CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
	<20120612132736.642a4a5a@pyramind.ukuu.org.uk>
	<CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
	<20120612170412.359967ec@pyramind.ukuu.org.uk>
Date: Tue, 12 Jun 2012 21:09:26 +0200
Message-ID: <CAMeQTsbAxToYhP4T+PRsaTq-wrX4yCprM=jCfK8NRWi21Avzvw@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 6:04 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Was there a special reason for 0x4108 to be left out in the IS_MRST macro?
>> To me it looks like the bitmask should have been updated in commit:
>>
>> gma500: Add the E6xx PCI identifier we are missing
>> 56125db1eecf8d34d84f7925686110d90724edf0
>>
>> If this is the case, I'll send a proper patch since this also applies to
>> stable 3.3.x and 3.4.x
>
> Firstly it should never matter - there are no Moorestown devices in
> circulation. E600T is very similar to Oaktrail.
>
> So the real question here seems to be why does the IS_MRST macro matter.
> What weird firmware is involved here ?

It matters because everything between 0x4100 - 0x4107 are Moorestown if you ask
the macro, but are assigned to oaktrail_chip_ops. That makes Oaktrail ==
Moorestown. IS_OAK might be a more appropriate name.

IS_MRST is primarily used for two things:
1) Take LVDS enable fuse value into account
2) Tell that LVDS must be on Pipe A

Those things where required for him to get the panel working,
so why not include the 0x4108 in the IS_MRST check?

-Patrik
