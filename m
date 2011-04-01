Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1DASBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:01:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50256 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1DASBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
References: <20110202195417.228e2656@queued.net> <20110202200812.3d8d6cba@queued.net>
 <20110331230522.GI437@ponder.secretlab.ca> <20110401112030.GA3447@sortiz-mobl>
 <20110401104756.2f5c6f7a@debxo> <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 1 Apr 2011 12:00:57 -0600
X-Google-Sender-Auth: OG5XJ8U0gw1sDkll9tIsXR-eunE
Message-ID: <BANLkTin5ZdQ+i7e6O98jKux+V7Ncc5Kb3Q@mail.gmail.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available to drivers
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 11:56 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Apr 1, 2011 at 11:47 AM, Andres Salomon <dilinger@queued.net> wrote:
>> On Fri, 1 Apr 2011 13:20:31 +0200
>> Samuel Ortiz <sameo@linux.intel.com> wrote:
>>
>>> Hi Grant,
>>>
>>> On Thu, Mar 31, 2011 at 05:05:22PM -0600, Grant Likely wrote:
>> [...]
>>> > Gah.  Not all devices instantiated via mfd will be an mfd device,
>>> > which means that the driver may very well expect an *entirely
>>> > different* platform_device pointer; which further means a very high
>>> > potential of incorrectly dereferenced structures (as evidenced by a
>>> > patch series that is not bisectable).  For instance, the xilinx ip
>>> > cores are used by more than just mfd.
>>> I agree. Since the vast majority of the MFD subdevices are MFD
>>> specific IPs, I overlooked that part. The impacted drivers are the
>>> timberdale and the DaVinci voice codec ones.
>
> Another option is you could do this for MFD devices:
>
> struct mfd_device {
>        struct platform_devce pdev;
>        struct mfd_cell *cell;
> };
>
> However, that requires that drivers using the mfd_cell will *never*
> get instantiated outside of the mfd infrastructure, and there is no
> way to protect against this so it is probably a bad idea.
>
> Or, mfd_cell could be added to platform_device directly which would
> *by far* be the safest option at the cost of every platform_device
> having a mostly unused mfd_cell pointer.  Not a significant cost in my
> opinion.
>
> One last option is I'm prototyping a way to add type-safe structure
> pointers to a device, but that requires nasty CPP tricks and it's not
> complete yet.  The cure might be worse than the disease here.

And yet another option is to create a mfd_bus_type, but that probably
isn't helpful since the one of the purposes of MFDs is that it is a
collection of non-detectable memory mapped devices that
platform_bus_type is intended to handle.

g.
