Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2BXE4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:56:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2BXE4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:56:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.156.225 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <201202221000.00810.arnd@arndb.de>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
	<20120220022729.GJ3194@opensource.wolfsonmicro.com>
	<CAJ0PZbTRRsyF4tGSYPagVmZQ495bmduYZ+FfPjn=Kp9hhcmhxQ@mail.gmail.com>
	<201202221000.00810.arnd@arndb.de>
Date: Fri, 24 Feb 2012 13:56:06 +0900
Message-ID: <CAJ0PZbR+AEpfNcX0wMHdVQfseC+fMxJjyaM25378miLnnfV0+w@mail.gmail.com>
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

On Wed, Feb 22, 2012 at 7:00 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 22 February 2012, MyungJoo Ham wrote:
>>
>> On Mon, Feb 20, 2012 at 11:27 AM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>> > On Fri, Feb 10, 2012 at 03:40:37PM +0900, MyungJoo Ham wrote:
>> >
>> >> +What:                /sys/class/extcon/.../mutually_exclusive
>> >> +Date:                December 2011
>> >> +Contact:     MyungJoo Ham <myungjoo.ham@samsung.com>
>> >> +Description:
>> >> +             Shows the relations of mutually exclusiveness. For example,
>> >> +             if the mutually_exclusive array of extcon_dev is
>> >> +             {0x3, 0x5, 0xC, 0x0}, the, the output is:
>> >> +             # cat mutually_exclusive
>> >> +             0x3
>> >> +             0x5
>> >> +             0xC
>> >> +             #
>> >
>> > sysfs really isn't supposed to have more than one value per file so this
>> > should be something like a directory with one array element per file.
>> > It'd kind of be cheating but the values could be used as the filenames,
>> > though serial numbers would be more idiomatic.
>>
>> Hmm.. I'll either use multiple files with a sub-directory or bin-attr
>> to inhabit the values. Or I'll search for any other convinient way to
>> express such an array thru sysfs.
>
> How about having one file for each cable and list the ones that it
> cannot coexist with. In the above example, that would become
>
> mutually_exclusive/0: "0x6"
> mutually_exclusive/1: "0x1"
> mutually_exclusive/2: "0x9"
> mutually_exclusive/3: "0x4"
>
> The information here is a bit redundant, but this would be much easier
> to understand for human readers. I also wouldn't mind having a list
> of exclusive cable names in each file, while would make it slightly
> harder to parse but very easy for humans:
>
> mutually_exclusive/Video-in: "VGA"
> mutually_exclusive/Video-out: "VGA"
> mutually_exclusive/VGA: "Video-out Video-in"
>
>        Arnd

Ok, here goes an example how it would look like in the next revision of Extcon.
I think this addresses your comments on multistate-support patch (3/5)

/sys/class/extcon/max8997-muic.0/
        name: "max8997-muic.0"
        state: 0x00000009                   /* RW. 0xblahblah format
for both read and write */
        mutually_exclusive/
                rule.0: 0x3
                rule.1: 0x5
                rule.2: 0xC
        cable.0/
                name: "VGA"
                state: 1            /* RW: 0 or 1 */
                mutually_exclusive/
                        cable.1
                        cable.2
        cable.1/
          ...


How about this?




Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
