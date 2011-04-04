Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1DDNZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:25:23 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:55779 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1DDNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:25:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D99C720.8030208@cam.ac.uk>
Date: Mon, 04 Apr 2011 14:26:56 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: michael.hennerich@analog.com,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev
 combining and rewrite of triggers as 'virtual' irq_chips.
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk> <4D99B34B.9050309@analog.com> <4D99C4D7.1010706@cam.ac.uk>
In-Reply-To: <4D99C4D7.1010706@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/11 14:17, Jonathan Cameron wrote:
> On 04/04/11 13:02, Michael Hennerich wrote:
>> On 03/31/2011 04:53 PM, Jonathan Cameron wrote:
>>> Dear All,
>>>
>>> I'm afraid what in many ways makes sense as three separate
>>> series have gotten rather intertwined.  I can probably unpick
>>> them but it will involve a lot of intermediate code in
>>> lis3l02dq (which is our fiddly example for this set) that I'd
>>> rather avoid.  Hence lets have a guide to what various people
>>> might be interested in:
>>>
>>> 1) Channel registration rework (this has previous been in linux-iio
>>>    but really comes into it's own after we remove various special
>>>    cases later in this code).
>>>
>>>    Patches 1, 2, 3, 21
>>>    (8) - cleanups Arnd Bergmann pointed out in passing.
>>>   
>> Good approach. It removes quite a bit on duplicated code across drivers.
>> At the moment I can't think of existing drivers that couldn't moved over
>> to the
>> new channel registration method.
> There are a few that will require quite a bit more code - principally the
> light sensors with their rather odd channel naming.  I'll do one of those
> shortly and see what we end up with.
> 
>> However there are some limitations.
>> read_raw() value is currently type int, depending on the channel type,
>> int type might be too short.
> True. How far do you think we should go?  s64? I did wonder if it makes sense
> to have two value pointers (perhaps NULL)  So base unit (val1) and
> decimal places of base unit (val2).
> 
> So true raw values (e.g. sensor readings) will only set val1, but we have plenty
> of space for things like scale at sufficient accuracy.  That also means we can
> flatten together the attributes in the core for both cases (not a great saving
> but nice to have none the less).
Oops, obviously if we do combine the functions then passing NULL pointers is
nonsensical. Perhaps the return value can indicate which parts are meaningful.
> 
> What do you think?
> 
