Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1IBPbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:31:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2517 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1IBPbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:31:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 02 Sep 2011 08:30:33 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, Andrew Chew <AChew@nvidia.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Date: Fri, 2 Sep 2011 08:30:31 -0700
Subject: RE: [PATCH V2 1/4] i2c: Add irq_gpio field to struct i2c_client.
Thread-Topic: [PATCH V2 1/4] i2c: Add irq_gpio field to struct i2c_client.
Thread-Index: AcxpS++wHWoM4TO2QOazlAVlhsuZtgAONe0g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A55D@HQMAIL01.nvidia.com>
References: <1314895964-15964-1-git-send-email-swarren@nvidia.com>
 <1314895964-15964-5-git-send-email-swarren@nvidia.com>
 <4E60985B.6010901@cam.ac.uk>
In-Reply-To: <4E60985B.6010901@cam.ac.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote at Friday, September 02, 2011 2:48 AM:
> On 09/01/11 17:52, Stephen Warren wrote:
> > Some devices use a single pin as both an IRQ and a GPIO. In that case,
> > irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
> > Where they do, and the use of this feature is optional, and the system
> > wishes to disable this feature, this field must be explicitly set to a
> > defined invalid GPIO ID, such as -1.
>
> Why make it specifically an irq related gpio?  Might as well just call it
> gpio then it can be used for cases where it never corresponds to an irq
> such as capture trigger pins.
> 
> Otherwise I'd be happy to see this go in.

The idea was specifically to replace the need to call irq_to_gpio(i2c->irq).
If we did just rename it plain "gpio" and allow it to be used for anything,
then that does indeed start looking more like device-specific platform data.

I guess it sounds like consensus is to go that way. It does seem like that
will end up creating a bunch more device-specific platform-data files though.
I wonder if adding IORESOURCE_GPIO would make sense so this could be handled
in a generic way without custom platform data types?

-- 
nvpublic

