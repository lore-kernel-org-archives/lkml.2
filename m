Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1JMOqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:46:06 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:55373 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1JMOqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:46:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E96F9AC.9000001@cam.ac.uk>
Date: Thu, 13 Oct 2011 15:46:04 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, zdevai@gmail.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk> <1318333383-17663-2-git-send-email-jic23@cam.ac.uk> <20111013143224.GO1098@sirena.org.uk>
In-Reply-To: <20111013143224.GO1098@sirena.org.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/11 15:32, Mark Brown wrote:
> On Tue, Oct 11, 2011 at 12:43:03PM +0100, Jonathan Cameron wrote:
> 
>> +struct iio_dev *iio_find_dev(const char *name);
>> +void iio_release_dev(struct iio_dev *indio_dev);
> 
> This looks like it should really be clk style with a struct device and a
> back end interface that deals with mapping the provider to consumers at
> runtime.
Agreed.  That definitely looks like the best discovery interface
out there at the moment.  Will reroll with the equivalent.

We'll have to play a few games in the drivers to map back to the underlying
bus names so that we have consistent naming.  (simple callback).
> 
>> +	/* read from channel 1 and exit */
>> +	ret = indio_dev->info->read_raw(indio_dev, &indio_dev->channels[0], &val, &val2, 0);
> 
> I guess an actual implementation would have wrappers for doing the
> indirections rather than having users peer into the ops table directly?
> 
Yup, for some reason the cover letter seems to have detached from this.
It suggested exactly that.  There may be weird cases where peering this
deep into the ops makes sense, but not for something like this one.

