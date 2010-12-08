Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0LHXI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:08:56 -0500
Received: from kroah.org ([198.145.64.141]:47244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0LHXIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:08:54 -0500
Date: Wed, 8 Dec 2010 15:08:02 -0800
From: Greg KH <greg@kroah.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: linux-omap <linux-omap@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Nishanth Menon <nm@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Armando Uribe De Leon <x0095078@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ernesto Ramos Falcon <ernesto@ti.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Rene Sapiens <rene.sapiens@ti.com>
Subject: Re: [PATCH] staging: tidspbridge: remove file handling functions
 for loader
Message-ID: <20101208230802.GA8176@kroah.com>
References: <1291702146-17866-1-git-send-email-omar.ramirez@ti.com>
 <20101208222642.GA31802@kroah.com>
 <AANLkTikcuqWbV1xGhirL65YKRjVW=2JcdYw272a0AJSN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikcuqWbV1xGhirL65YKRjVW=2JcdYw272a0AJSN@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 05:02:20PM -0600, Ramirez Luna, Omar wrote:
> Hi,
> 
> On Wed, Dec 8, 2010 at 4:26 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Dec 07, 2010 at 12:09:06AM -0600, Omar Ramirez Luna wrote:
> >> Instead use request_firmware and friends to get a valid firmware
> >> image.
> >>
> >> Right now the image is supplied dynamically through udev and the
> >> following rule:
> >>
> >> KERNEL=="omap-dsp", SUBSYSTEM=="firmware", ACTION=="add",     \
> >>       RUN+="/bin/sh -c 'echo 1 > /sys/$DEVPATH/loading;       \
> >>               cat $FIRMWARE > /sys/$DEVPATH/data;             \
> >>               echo 0 > /sys/$DEVPATH/loading'"
> >
> > Why do you need a custom firmware rule?
> 
> It was meant as an example, when I compiled my minimal file system it
> didn't supply the firmware.sh script nor created /lib/firmware... I
> thought that not everybody would have the firmware.sh, so I just
> provided a sample rule.

So, can I remove this from the changelog comment, as it's not really
needed at all?

> >  Why doesn't the default  firmware loading rule that comes with udev work properly for you?
> > What are you needing different here that works properly for all other drivers?
> 
> firmware.sh under /lib/udev/ and dsp binaries installed under
> /lib/firmware/, my rule is the brute version of firmware.sh so nothing
> different in the script.
> 
> Probably the only change would be to supply the firmware name only, as
> of now the insmod parameter requires the entire path, e.g.:
> 
> insmod bridgedriver.ko base_img=/lib/dsp/baseimage.dof
> 
> if using firmware.sh and placing firmware files under /lib/firmware/, then
> 
> insmod bridgedriver.ko base_img=baseimage.dof

Ick, why use a module parameter name at all?  Why is this "special" and
different from all other firmware users?  They don't have to manually
specify a file name, the driver does that.

Please fix up the patch to not require a module parameter, distros hate
them, and users hate them even more.

thanks,

greg k-h
