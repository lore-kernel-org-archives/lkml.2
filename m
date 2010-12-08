Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0LHXcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:32:53 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:53412 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab0LHXcv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:32:51 -0500
MIME-Version: 1.0
In-Reply-To: <20101208230802.GA8176@kroah.com>
References: <1291702146-17866-1-git-send-email-omar.ramirez@ti.com>
	<20101208222642.GA31802@kroah.com>
	<AANLkTikcuqWbV1xGhirL65YKRjVW=2JcdYw272a0AJSN@mail.gmail.com>
	<20101208230802.GA8176@kroah.com>
Date: Wed, 8 Dec 2010 17:32:50 -0600
Message-ID: <AANLkTinGsYVTPV-kQHkA7U20pGX86Z-t46AGBe3pEkO7@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: remove file handling functions for loader
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Greg KH <greg@kroah.com>
Cc: linux-omap <linux-omap@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Nishanth Menon <nm@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Armando Uribe De Leon <x0095078@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ernesto Ramos Falcon <ernesto@ti.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Rene Sapiens <rene.sapiens@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 5:08 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Dec 08, 2010 at 05:02:20PM -0600, Ramirez Luna, Omar wrote:
>> Hi,
>>
>> On Wed, Dec 8, 2010 at 4:26 PM, Greg KH <greg@kroah.com> wrote:
>> > On Tue, Dec 07, 2010 at 12:09:06AM -0600, Omar Ramirez Luna wrote:
>> >> Instead use request_firmware and friends to get a valid firmware
>> >> image.
>> >>
>> >> Right now the image is supplied dynamically through udev and the
>> >> following rule:
>> >>
>> >> KERNEL=="omap-dsp", SUBSYSTEM=="firmware", ACTION=="add",     \
>> >>       RUN+="/bin/sh -c 'echo 1 > /sys/$DEVPATH/loading;       \
>> >>               cat $FIRMWARE > /sys/$DEVPATH/data;             \
>> >>               echo 0 > /sys/$DEVPATH/loading'"
>> >
>> > Why do you need a custom firmware rule?
>>
>> It was meant as an example, when I compiled my minimal file system it
>> didn't supply the firmware.sh script nor created /lib/firmware... I
>> thought that not everybody would have the firmware.sh, so I just
>> provided a sample rule.
>
> So, can I remove this from the changelog comment, as it's not really
> needed at all?

Yes it can be removed.

BTW, I don't expect this pushed through staging yet, I need to include
it to my branch first and then I'll send a pull request with the pile
of patches. Sorry for the misunderstanding and thanks for the review.

>> insmod bridgedriver.ko base_img=baseimage.dof
>
> Ick, why use a module parameter name at all?  Why is this "special" and
> different from all other firmware users?  They don't have to manually
> specify a file name, the driver does that.

The thing is that there are N number of firmwares, e.g.:

There is the official and usable firmware to play with multimedia
"baseimage.dof"

But there are also minimal firmwares to just ping or swap buffers with
the dsp, when you just want to play around with basic features.

> Please fix up the patch to not require a module parameter, distros hate
> them, and users hate them even more.

The driver is the one requiring the parameter (it was already this
way), this patch doesn't introduce any parameter. I'll check what can
be done and if nobody rejects I'll use the baseimage.dof  as firmware
by default.

Regards,

Omar
