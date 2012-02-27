Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2B0Grd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:47:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2B0Grc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:47:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.203.98 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <201202241253.52336.arnd@arndb.de>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
	<201202221000.00810.arnd@arndb.de>
	<CAJ0PZbR+AEpfNcX0wMHdVQfseC+fMxJjyaM25378miLnnfV0+w@mail.gmail.com>
	<201202241253.52336.arnd@arndb.de>
Date: Mon, 27 Feb 2012 15:47:32 +0900
Message-ID: <CAJ0PZbSdm90=14Og4HSo+UoB5gNPfeXWnC-hiX6rw6WBTs9vTQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] Extcon: support mutually exclusive relation
 between cables.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 9:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 24 February 2012, MyungJoo Ham wrote:
>> Ok, here goes an example how it would look like in the next revision of Extcon.
>> I think this addresses your comments on multistate-support patch (3/5)
>>
>> /sys/class/extcon/max8997-muic.0/
>>         name: "max8997-muic.0"
>>         state: 0x00000009                   /* RW. 0xblahblah format
>> for both read and write */
>>         mutually_exclusive/
>>                 rule.0: 0x3
>>                 rule.1: 0x5
>>                 rule.2: 0xC

==> I'll simply add 0x3, 0x5, 0xc as the filenames insteadof rule.0 .. 2.

>>         cable.0/
>>                 name: "VGA"
>>                 state: 1            /* RW: 0 or 1 */
>>                 mutually_exclusive/
>>                         cable.1
>>                         cable.2

==> Removing this subdirectory, "mutually_exclusive"

>>         cable.1/
>>           ...
>>
>>
>> How about this?
>>
>
> I would leave out the global mutually_exclusive/ directory because that
> is redundant and I see no benefit in it. Having the redundant "state"
> files is probably a good idea because the global one lets you make
> atomic changes of multiple cables and the other are very convenient.
>
> What kind of object is /sys/class/extcon/max8997-muic.0/cable.0/mutually_exclusive?
> Is that a file with two lines, a directory with two empty files or
> a directory with symlinks to the other directories?

I meant it to be a directory containing attributes (w/o show/store
callbacks) with names of exclusive cables.

However, because we cannot make 2nd-subdirectories under a kobject (I
didn't know this until some hours ago), it appears that I need to
avoid this approach until it is allowed to do so.

Because the redundant information is in the global mutually_exclusive
directory, I'll skip this one (mutually_exclusive subdirectory under
cable.x subdirectory).


>
>        Arnd





Cheers!
MyungJoo.
-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
