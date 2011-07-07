Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1GGRP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab1GGRP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:15:26 -0400
Message-ID: <4E15E9AC.9050800@redhat.com>
Date: Thu, 07 Jul 2011 14:15:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFCv3 03/17] [media] DocBook: Use the generic error code
 page also for MC API
References: <cover.1309974026.git.mchehab@redhat.com> <20110706150352.436f7a2a@pedra> <201107071729.03676.hverkuil@xs4all.nl>
In-Reply-To: <201107071729.03676.hverkuil@xs4all.nl>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-07-2011 12:29, Hans Verkuil escreveu:
> On Wednesday, July 06, 2011 20:03:52 Mauro Carvalho Chehab wrote:
>> Instead of having their own generic error codes at the MC API, move
>> its section to the generic one and be sure that all media ioctl's
>> will point to it.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
>> index 6ef476a..a7f73c9 100644
>> --- a/Documentation/DocBook/media/v4l/gen-errors.xml
>> +++ b/Documentation/DocBook/media/v4l/gen-errors.xml
>> @@ -5,6 +5,11 @@
>>    <tgroup cols="2">
>>      &cs-str;
>>      <tbody valign="top">
>> +	<!-- Keep it ordered alphabetically -->
>> +      <row>
>> +	<entry>EBADF</entry>
>> +	<entry><parameter>fd</parameter> is not a valid open file descriptor.</entry>
>> +      </row>
>>        <row>
>>  	<entry>EBUSY</entry>
>>  	<entry>The ioctl can't be handled because the device is busy. This is
>> @@ -15,7 +20,16 @@
>>  	       problem first (typically: stop the stream before retrying).</entry>
>>        </row>
>>        <row>
>> +	<entry>EFAULT</entry>
>> +	<entry><parameter>fd</parameter> is not a valid open file descriptor.</entry>
> 
> This seems to be a copy-and-paste error. The original text in media-func-ioctl.xml says this:
> 
> 	  <para><parameter>argp</parameter> references an inaccessible memory
> 	  area.</para>

Ah, yes. Anyway, a latter patch changes it to:

	<entry>EFAULT</entry>
	<entry>There was a failure while copying data from/to userspace.</entry>
      </row>

referencing a parameter name there is a bad thing anyway, as this is now at the common
ioctl error code.

Instead of just using a posix-like error code:
	EFAULT          Bad address (POSIX.1)

I opted to use a more valuable description, explaining the reason for such error,
e. g. that there was a failure at the data copy from/to userspace.

It may be better to change it to:

	<entry>EFAULT</entry>
	<entry>There was a failure while copying data from/to userspace, probably
		caused by an invalid pointer reference.</entry>

I think I'll add the above description at the latter patch.

I was intending to add there the other possible error causes found at V4L/DVB API's
and drivers, but the changes I did took me a longer time than I was expecting
originally.  I'll eventually do that when I have more time. 

It would be really great if we could find some volunteer to help syncing 
the media API specs with the code.

>> +      </row>
>> +      <row>
>>  	<entry>EINVAL</entry>
>> +	<entry>One or more of the ioctl parameters are invalid. This is a widely
> 
> widely -> widely used
> 
>> +	       error code. see the individual ioctl requests for actual causes.</entry>
> 
> see -> See

Fixed. 

Thanks!
Mauro
