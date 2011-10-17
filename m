Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1JQKcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:32:02 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:56609 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1JQKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 06:32:00 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9C0423.5010909@cam.ac.uk>
Date: Mon, 17 Oct 2011 11:32:03 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk> <1318333383-17663-2-git-send-email-jic23@cam.ac.uk> <20111013143224.GO1098@sirena.org.uk> <4E96F9AC.9000001@cam.ac.uk> <20111013204410.GA17160@sirena.org.uk> <4E985C60.9020308@cam.ac.uk> <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com> <4E9BF8D9.8030301@cam.ac.uk> <20111017101959.GC3042@opensource.wolfsonmicro.com>
In-Reply-To: <20111017101959.GC3042@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 11:19, Mark Brown wrote:
> On Mon, Oct 17, 2011 at 10:43:53AM +0100, Jonathan Cameron wrote:
> 
>> For the adc channel I'm not particularly keen on insisting every device
>> have a unique name for every channel.  That breaks the effort we went to
>> in IIO to enforce consistent naming (for userspace interfaces) in the first
>> place.  To my mind it should never be anything other than a number.
> 
> I think you want something similar to what we do with platform devices -
> have both a name and a number.  For devices that are just a bunch of
> symmetric channels (which seems to be the main case you're thinking of)
> the name would always be the same and the number would vary but if the
> device has a bunch of different functions then they'd be named.  That
> way you don't have to remember that the channels of a given type start
> at offset X.
> 
> For example, on a PMIC you'll often have ADC channels wired up to
> specific supplies plus some extras which are left for board use.  The
> fixed channels might get named after the supplies and the extras all
> have the same name distinguished by number.
> 
We effectively have the equivalent already - I can add it to the query
interface.  It allows channels to have a supplementary name typically
if they are measuring something not of general purpose (such as the
sensor supply voltage).

I'd also allow for name to be NULL - it provides no information at all
for a lot of devices.

Note, if we are talking functions such 'acceleration' then I'd much
rather have explicit enums for type, direction etc in there.  This
means that we are mapping onto the full channel spec rather than the
channel index. Really don't want strings on the adc side (except for
special cases as described above) as I just spent rather a long time
ripping them out precisely to enforce a consistent interface where
there was previously too much flexibility.

We have a system that allows describing of more or less everything we
have ever encountered in a rigorous consistent fashion (I say almost
as there is a slight wrinkle with some dds channels as currently defined).

Initially I'd be tempted to only support numbered channels (on adc side).
Later we can add the named option - iff it has real use cases.

Jonathan
