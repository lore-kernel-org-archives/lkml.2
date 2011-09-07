Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1IGSEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:04:24 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:45247 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IGSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:04:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E67B415.6000106@cam.ac.uk>
Date: Wed, 07 Sep 2011 19:12:37 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: Blockers on IIO usage of regmap.
References: <4E6600A8.4020101@cam.ac.uk> <20110906175435.GA2924@opensource.wolfsonmicro.com> <Prayer.1.3.4.1109062213100.4243@hermes-2.csi.cam.ac.uk> <4E679770.4090008@cam.ac.uk> <20110907175756.GH2906@opensource.wolfsonmicro.com>
In-Reply-To: <20110907175756.GH2906@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 18:57, Mark Brown wrote:
> On Wed, Sep 07, 2011 at 05:10:24PM +0100, Jonathan Cameron wrote:
> 
> Please fix your mailer to word wrap at less than 80 colums, they're
> really quite hard to read as a result of this.
> 
>> CS -_______________________-
>> TX  Ada0...Ada7  Da0....Da7
>> RX XXXXXXXXXXXXXXXXXXXXXXXXX
>>
>> Reads are 16 bit with either of the two 8 bit register addresses given the same value
>>
>> CS -______________________-_____________________-
>> TX  Ada0....Ada7 XXXXXXXX
>> RX  XXXXXXXXXXXXXXXXXXXXX  Da0...Da7  Db0....Db7  
> 
>> Can interpret Da0...Da7 and Db0....Db7 as single 16 bit register and consider this device
>> to just have a weird write method and normal read.  Might be easier.  I'll define Ax<n> as
>> 16 bit address for the burst read.
> 
> This is starting to seem pretty far off the reservation.
Indeed.
> 
>> Perhaps the burst mode thing is better handled by just providing a hook to allow data to be pushed
>> into regmap (from 'magic' sources), but the weird write read combination looks to me like something
>> that makes sense to have in regmap (be it as another bus variant).
> 
> Probably not as a bus, it sounds like a marshalling difference rather
> than a bus - the buses should really only understand byte streams.  I
> don't have any bright ideas on how to deal with this, it's fairly far
> away from the problem space I'm worried about.
The right answer maybe that it isn't a good idea to do it at all, but it
wasn't obvious until I tried! Having done it I'm not sure either way.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

