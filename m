Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0JNKPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:15:33 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:49061 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab0JNKPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:15:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CB6D995.9020907@cam.ac.uk>
Date: Thu, 14 Oct 2010 11:21:09 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100928 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Drivers <Drivers@analog.com>
Subject: Re: linux-next: Tree for October 13 (staging/iio)
References: <20101013154522.7b087a20.sfr@canb.auug.org.au> <20101013094117.530baa63.randy.dunlap@oracle.com> <544AC56F16B56944AEC3BD4E3D59177130943738AE@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D59177130943738AE@LIMKCMBX1.ad.analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/10 20:07, Hennerich, Michael wrote:
> Randy Dunlap wrote on 2010-10-13:
>> On Wed, 13 Oct 2010 15:45:22 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20101012:
>>
>>
>> drivers/staging/iio/adc/ad7476.h:62: note: expected 'struct device *'
>> but argument is of type 'struct ad7476_state *'
>> drivers/staging/iio/adc/ad7476_core.c:48: error: too few arguments to
>> function 'ad7476_scan_from_ring'
> 
> Thanks!
> 
> That's due to an old prototype active when CONFIG_IIO_RING_BUFFER is not set.
> I'll fix that.
> 
>> drivers/staging/iio/adc/ad7476_core.c: At top level:
>> drivers/staging/iio/adc/ad7476_core.c:102: error:
>> 'IIO_SCAN_EL_TYPE_UNSIGNED' undeclared here (not in a function)
> 
> Jonathan,
> 
> Do we really need to guard the entire ring_generic.h header with
> 
> #ifdef CONFIG_IIO_RING_BUFFER
> ...
> 
> Some of these might be used, even when CONFIG_IIO_RING_BUFFER is not set.
> Or do we really need CONFIG_IIO_RING_BUFFER at all.
> Why not always provide it?
It's a fairly big chunk of code and I suspect a fair few of our users
(all the light sensors for starters) won't want it at all.  If anything
I'm keen to do a bit of reorganization of other bits of the core to
further cut down on the minimum present.

Move relevant functions out as needed or put stubs in place.  Perhaps we
can revisiting this question down the line, but I don't think we want to
make buffer support obligatory at the moment.

Jonathan
> 
>>
>> config is attached.
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your
>> code ***
> 
> Greetings,
> Michael
> 
> Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
> Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
> 
> 
> 

