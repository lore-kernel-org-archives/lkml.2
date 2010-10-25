Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0JYOGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:06:37 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:42899 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0JYOGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:06:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CC59048.4060600@cam.ac.uk>
Date: Mon, 25 Oct 2010 15:12:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Ben Dooks <ben-i2c@fluff.org>
CC: Mike Frysinger <vapier@gentoo.org>, Jean Delvare <khali@linux-fr.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        David Brownell <david-b@pacbell.net>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Device-drivers-devel] [PATCH] i2c: add irq_flags to board info
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org> <20101018103610.77b7e605@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520EDB@LIMKCMBX1.ad.analog.com> <20101018140136.2b44d29e@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com> <20101018163357.659efe25@endymion.delvare> <AANLkTi=fAYqxsGre9kOt9Z8nDXZ9JFjZtKUiMrE3Qn9b@mail.gmail.com> <20101025004541.GD21564@trinity.fluff.org>
In-Reply-To: <20101025004541.GD21564@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/10 01:45, Ben Dooks wrote:
> On Mon, Oct 18, 2010 at 03:51:49PM -0400, Mike Frysinger wrote:
>> On Mon, Oct 18, 2010 at 10:33, Jean Delvare wrote:
>>> Why do we have set_irq_type() if we're not supposed to call it? I am
>>> not claiming to be an expert in the area, but it seems totally
>>> reasonable to me that the same piece of code instantiating an I2C
>>> device is also responsible for setting its IRQ type.
>>
>> but we're back to the same issue mentioned earlier -- you cant have a
>> single kernel build with modules supporting multiple drivers
>> simultaneously.  we like to ship development boards with a single
>> kernel build on it with many modules.  then people can pick the addon
>> boards they wish to prototype with at runtime by plugging in the card
>> and loading the module.
> 
> I also dislike set_irq_type() as it doesn't check whether there is anyone
> registered with the interrupt, which means that you could set the irq
> type of someone else's irq.
> 
> I wonder if we should pass a struct resource instead, in case there
> are multiple interrupt sources, as well as having it registered with
> the right resource systems.
> 
Either works as far as I am concerned. Having seen a large set of drivers
using the flags option (posted to linux-iio yesterday) I'm definitely convinced
some means of allowing devices to match what the board config asks for is useful.

I personally prefer the struct resource option as I have multiple drivers in IIO
which have two interrupts and this is the only reason some of them use platform
data.

Thanks,

Jonathan
