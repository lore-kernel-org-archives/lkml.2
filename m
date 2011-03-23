Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1CWQg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:36:27 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36620 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab1CWQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:36:25 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D8A21D4.6070102@cam.ac.uk>
Date: Wed, 23 Mar 2011 16:37:40 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of existing
 in kernel equivalents.
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk> <1300887554-19031-2-git-send-email-jic23@cam.ac.uk> <AANLkTimeEKjVwwYi+twb0oeoFK-33LMx5aQBZEnPodne@mail.gmail.com> <20110323160120.GA8770@kroah.com> <4D8A1CB7.4090505@cam.ac.uk> <20110323162351.GB9367@kroah.com>
In-Reply-To: <20110323162351.GB9367@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/11 16:23, Greg KH wrote:
> On Wed, Mar 23, 2011 at 04:15:51PM +0000, Jonathan Cameron wrote:
>> On 03/23/11 16:01, Greg KH wrote:
>>> On Wed, Mar 23, 2011 at 05:30:11PM +0200, Alexey Dobriyan wrote:
>>>> On Wed, Mar 23, 2011 at 3:39 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>>>>> +int kstrtobool(const char *s, bool *res)
>>>>> +{
>>>>> +       switch (s[0]) {
>>>>> +       case 'y':
>>>>> +       case 'Y':
>>>>> +       case '1':
>>>>> +               *res = true;
>>>>> +       case 'n':
>>>>> +       case 'N':
>>>>> +       case '0':
>>>>> +               *res = false;
>>>>> +       default:
>>>>> +               return -EINVAL;
>>>>> +       }
>>>>> +       return 0;
>>>>> +}
>>>>
>>>> sigh... such simple thing and so many bugs
>> Yeah, not by best work.
>>>>
>>>> The only values such function should accept is 0 and 1.
>>>
>>> Why?  That's not the way the existing kernel functions that use this
>>> work.
>>>
>>>> Have you read the rest of kstrto*() code?
>>>> Where is newline check?
>> There are plenty of nastier cases that get through than a newline
>> in the middle of the string (ybobsyouruncle -> 1 nyes->0 :)
>>>>
>>>> Anyway, I think it's better do not exist.
>>>
>>> I think it is, as it's already duplicated in at least 2 different places
>>> in the kernel, and probably more.  Once we get this implementation
>>> working correctly, we don't need to rewrite it again.
>> Perhaps naming it like this is a bad idea.  It manages to imply that it
>> has the same level of strict checking which is seen in the other kstrto*
>> functions - which is self evidently not true!
> 
> Ok, perhaps the name might need to be changed a bit, but the idea is
> still good to have.  Please try again.
> 
Any thoughts on what naming would work?  Nothing immediately comes to mind
which is why I ended up pinching the kstrto* naming...

reallysloppy_strtobool?
guessintent_strtobool?

or the old classic underscore prefix to 'encourage' people to check what it does
before using it

__strtobool?




