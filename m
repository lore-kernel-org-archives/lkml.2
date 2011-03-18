Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1CRQ2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:28:17 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:43591 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab1CRQ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:28:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D83885C.3050402@cam.ac.uk>
Date: Fri, 18 Mar 2011 16:29:16 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <201103181347.15291.arnd@arndb.de> <4D838313.9020804@cam.ac.uk> <201103181718.08502.arnd@arndb.de>
In-Reply-To: <201103181718.08502.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/11 16:18, Arnd Bergmann wrote:
> On Friday 18 March 2011, Jonathan Cameron wrote:
>> On 03/18/11 12:47, Arnd Bergmann wrote:
>>> On Thursday 17 March 2011, Jonathan Cameron wrote:
>>>> On 03/17/11 17:51, Arnd Bergmann wrote:
>>>>> I don't completely understand the notation. Regarding the various
>>>>> {in0, in1, in2, ...} inputs, is there a fundamental difference between
>>>>> them? In the code example I gave, a driver would simply list
>>>>> a set of inputs of the same type (IIO_CHAN_IN) and let the core
>>>>> enumerate them. What does "in0-in1" mean?
>>>>
>>>> in0-in1 is a differential adc channel. Literally outputs value on
>>>> physical pin 1 subtracted from physical pin 2.
>>>
>>> Ok, I see. So these would be fairly hard to enumerate, right?
>>> Would it be possible to have one attribute with named "diff%d"
>>> and another attribute associated with it that describes which
>>> channels are compared?
>>
>> Could do, but what would it gain us?  If the information is available
>> to the core, then it can use it give us the explicit naming? As shown
>> below we have to handle holes in the enumeration anyway so this isn't
>> to much of a problem.
> 
> Maybe I was seeing problems that don't exist here. Wouldn't
> you need to numeric identifiers to describe a differential
> channel?
Agreed, but from the point of view of what is exposed in naming it doesn't
matter.  The core and the driver need that number. Userspace doesn't.

Also note that we'll need to pass over an explicit index for the buffering
order anyway so what is one more.  The buffering one we can't avoid as
userspace has to know what it is and they are sometimes dependent on
really esoteric rules on the hardware.   Right now we assume that
there aren't sets with different contents where the ordering
of any given pair changes.  I think that is probably valid.
Hence what we have won't allow

a b c and b a d (in some sense they have to have a monotonic index).

> I guess if it's always in${i}-in${i+1}, it's still not too hard.
I think they have been so far, but doubt this is universal.
How about having a diff type and just having a pair of indices in the
channel structure?  Actually may need a third for x^2+y^2+z^2 devices.
(iirc there are parts that do x^2+y^2 despite also having a z channel)
...

