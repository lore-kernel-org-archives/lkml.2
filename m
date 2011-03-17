Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1CQOlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:41:40 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:42248 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1CQOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:41:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D821DE2.4050707@cam.ac.uk>
Date: Thu, 17 Mar 2011 14:42:42 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <201103161433.31303.arnd@arndb.de> <4D80CE2E.9000407@cam.ac.uk> <201103171447.17960.arnd@arndb.de>
In-Reply-To: <201103171447.17960.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/11 13:47, Arnd Bergmann wrote:
> I just went back to the older email and noticed that I missed some of your
> important replies.
> 
> On Wednesday 16 March 2011, Jonathan Cameron wrote:
>>> I'm slightly confused, mainly because I have no idea how the
>>> buffer and event interfaces are actually being used. I would
>>> have expected an interface as simple as:
>>>
>>> * One iio device per sensor that can provide data, possibly
>>>   many per hardware device
>>
>> One per device.
> 
> I'm not sure what that means. One iio device per hardware device?
Oops. That was particularly unclear!
> 
> What about hardware devices that have multiple unrelated streams
> of buffered input data?
Certainly plausible, but so far the only ones I've seen that actually
do this are really just two bits of silicon in the same plastic
package.  They tend to use different i2c addresses or spi chip
selects anyway so as far as the kernel is concerned are completely
separate.  You are correct that any device which truly has different
streams of data would indeed need more than one device.
> 
>>> * One chardev for each iio device
>>
>> currently 1-3. (event line, buffer access, buffer event)
> 
> It would be really nice to unify this, as I said. What
> are the reasons why you think it cannot or should not be
> done?
Simplicity perhaps, but I'll definitely give your suggestions
a go and see where we end up. 
> 
>>> * Use epoll to wait for data and/or out-of-band messages
>>> * Use chrdev read to get events from the buffer
>>
>> and data?
> 
> I mean get the data associated with the event. The event
> itself as you said does not have any data, so we would not
> need to read it, just to use poll()/epoll() in order to
> wait for it.
Sure. But devices can do a heck of a lot of different events.
(certainly 10's or maybe more).  I'm not immediately clear
on how to handle this via poll etc.  This is probably just
because I've never tried though!
> 
>>> * Use sysfs to read from sensors that are not event based
>>>
>>> What you have is obviously more complex than this, and you
>>> probably have good reasons that I still need to understand.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

