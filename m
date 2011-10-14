Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1JNP72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:59:28 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:56000 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1JNP71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:59:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E985C60.9020308@cam.ac.uk>
Date: Fri, 14 Oct 2011 16:59:28 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, zdevai@gmail.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk> <1318333383-17663-2-git-send-email-jic23@cam.ac.uk> <20111013143224.GO1098@sirena.org.uk> <4E96F9AC.9000001@cam.ac.uk> <20111013204410.GA17160@sirena.org.uk>
In-Reply-To: <20111013204410.GA17160@sirena.org.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/11 21:44, Mark Brown wrote:
> On Thu, Oct 13, 2011 at 03:46:04PM +0100, Jonathan Cameron wrote:
> 
>>> I guess an actual implementation would have wrappers for doing the
>>> indirections rather than having users peer into the ops table directly?
> 
>> Yup, for some reason the cover letter seems to have detached from this.
>> It suggested exactly that.  There may be weird cases where peering this
>> deep into the ops makes sense, but not for something like this one.
> 
> Oh, right.  As a general rule I don't read cover letters for single
> patches until after I've read the patch, generally they're either
> completely content free (if only by virtue of repeating the changelog)
> or there's a problem with the changelog in the actual patch not
> explaining what's going on.
Fair enough.

I'm trying to work out what our equivalent of the clk finding api is.

The best match pair to match on I can come up with is:

part name: iio_dev.name

dev_name of underlying hardware if specified.
dev_name(iio_dev->dev.parent)
This matching source can be overridden by an optional callback if we
unique matching is achievable in some other way for the device.

Typical pairs:

max1363, 0-0035
max1238, 0-0034
lis3l02dq spi1.0
adis16400 spi2.1

On soc ADCs can use any combination of the two that makes local
sense.

Does this look sufficient for description / identification?

Precedence order of both, then column 2 (lets call that id) and finally column 1
(part name).

The concept of connections doesn't make sense quite like it does for clks as
we are getting a reference to the whole device, then picking which bits we want
afterwards.


 

