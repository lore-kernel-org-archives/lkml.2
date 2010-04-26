Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0DZUH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:07:26 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:59067 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0DZUHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:07:24 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BD5F32E.5030208@cam.ac.uk>
Date: Mon, 26 Apr 2010 21:10:22 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 00/19 V2] staging:iio: ABi changes round 1
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need sleep...

Can't even remember the name of the iio list.  Sorry all.
Rather than reposting the whole series, I'll send a copy there as
well with a note to cc lkml and try and ensure anything of more
general interest does get sent on.

Jonathan
> Dear All,
> 
> The original patch set was sent to iio-linux@vger.kernel.org
> back in March.
> 
> Principally this updated set includes a number of minor fixes
> based on additional testing.  One or two of these patches are
> outright fixes that have been picked up by Greg in the meantime.
> Conversely this is based on mainline as of yesterday, so does not
> include all of the fixes that are in Greg's for next tree.
> 
> If people are in happy with these I will do a clean set suitable
> for direct use by Greg KH.
> 
> New stuff in here includes some additional support in the max1363
> driver.  This could do with a bit of testing, but these parts are
> extremely similar to those already supported so there should be
> no major issues.  Also included is a substantially rewritten example.
> 
> Next on my list for IIO is adding a couple of new buffer
> implentations, particularly playing with the new FIFO implementation.
> 
> As can be seen below the bulk of this set is a fairly substantial
> rewrite of max1363 required to have this device meet the new abi
> as it did not previously meet the last (undocumented) api!
> 
> There are still some issues with the api, particularly for naming
> of event parameters, but those will be ironed out in a second round
> of patches.
> 
> For convenience these are in a temporary git repository at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio-new-abi.git
> 
> Note that tree also includes some fixes and board support necessary
> for testing this patch set (if you have the platforms I do anyway)
> 
> As ever all coments welcome.  If quite reasonably people don't have
> time to look at the full set, please do offer comments on any you
> do have time to read!
> 
> Thanks,
> 
> Jonathan
> 
> Jonathan Cameron (19):
>   staging:iio: Add new in_raw definitions for adc channels.
>   staging:iio: Add new attrs for sampling frequency available and
>     temp_raw
>   iio:staging:accelerometers move towards the new abi
>   staging:iio: Support functions for scan mask matching
>   staging: iio: Move from class to bus
>   staging:iio: Move event attributes into the event[n] device in sysfs
>   staging:iio: Clean out unused IIO_SCAN_EL and add IIO_SCAN_NAMED_EL_C
>   staging:iio:max1363 move to new abi.
>   staging:iio: Documentation, update iio_utils.h for the move to a bus
>   staging:iio: ABI documentation (partial)
>   staging:iio: Directory name changes to match new ABI.
>   staging:iio:tsl2563: change lux to illuminanc0_input to match new abi
>   staging:iio: Remove naming via IDR's where no longer necessary under
>     new abi.
>   staging:iio:max1363 add support for max11606-max11617
>   staging:iio:max1363 add support for 8 bit equivalent devices,
>     max1036-9, max11600-5
>   Staging: IIO: Fix uses of spinlocks prior to init in ring
>     implementations
>   staging:iio:ring_sw: Fix incorrect test on successful read of last
>     value, causes infinite loop
>   staging:iio:tsl2563 add a name attribute under the iio
>   staging:iio:Documentation: Rewrite example for new abi.
> 
>  drivers/staging/iio/Documentation/iio_utils.h      |  266 +++--
>  .../iio/Documentation/lis3l02dqbuffersimple.c      |  237 +++--
>  drivers/staging/iio/Documentation/sysfs-class-iio  |  285 +++++
>  drivers/staging/iio/accel/accel.h                  |    8 +-
>  drivers/staging/iio/accel/kxsd9.c                  |   88 +-
>  drivers/staging/iio/accel/lis3l02dq.h              |    4 -
>  drivers/staging/iio/accel/lis3l02dq_core.c         |  175 ++--
>  drivers/staging/iio/accel/lis3l02dq_ring.c         |   10 +-
>  drivers/staging/iio/accel/sca3000.h                |    2 +
>  drivers/staging/iio/accel/sca3000_core.c           |  174 ++--
>  drivers/staging/iio/accel/sca3000_ring.c           |   33 +-
>  drivers/staging/iio/adc/Kconfig                    |   11 +-
>  drivers/staging/iio/adc/Makefile                   |    2 +-
>  drivers/staging/iio/adc/adc.h                      |   12 +
>  drivers/staging/iio/adc/max1363.h                  |  122 +--
>  drivers/staging/iio/adc/max1363_core.c             | 1109 ++++++++++++++------
>  drivers/staging/iio/adc/max1363_ring.c             |   80 +-
>  drivers/staging/iio/chrdev.h                       |    2 +-
>  drivers/staging/iio/iio.h                          |   47 +-
>  drivers/staging/iio/industrialio-core.c            |   58 +-
>  drivers/staging/iio/industrialio-ring.c            |   66 +-
>  drivers/staging/iio/industrialio-trigger.c         |    2 +-
>  drivers/staging/iio/light/tsl2563.c                |   16 +-
>  drivers/staging/iio/ring_generic.h                 |   50 +-
>  drivers/staging/iio/ring_sw.c                      |   23 +-
>  drivers/staging/iio/sysfs.h                        |   15 +-
>  26 files changed, 1955 insertions(+), 942 deletions(-)
>  create mode 100644 drivers/staging/iio/Documentation/sysfs-class-iio
> 
> 

