Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1CWKwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:52:44 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:32896 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab1CWKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:52:42 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D89D144.1040705@cam.ac.uk>
Date: Wed, 23 Mar 2011 10:53:56 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Subject: Re: Standard handling of boolean attributes in sysfs.
References: <4D87AEE0.8000807@cam.ac.uk> <20110321201411.GA1704@kroah.com> <4D88811F.7060901@cam.ac.uk> <20110322223013.GB31312@kroah.com>
In-Reply-To: <20110322223013.GB31312@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/11 22:30, Greg KH wrote:
> On Tue, Mar 22, 2011 at 10:59:43AM +0000, Jonathan Cameron wrote:
>> On 03/21/11 20:14, Greg KH wrote:
>>> On Mon, Mar 21, 2011 at 08:02:40PM +0000, Jonathan Cameron wrote:
>>>> Hi All,
>>>>
>>>> Just wondering what the feeling would be about having
>>>> a utility function similar to sysfs_streq to provide a
>>>> consistent option for all those sysfs attributes out there
>>>> where
>>>>
>>>> 1, on, true -> 1
>>>> 0, off, false -> 0
>>>>
>>>> Or does such a beast already exist and I'm just being unobservant?
>>>
>>> We have the one in debugfs that I think people use for sysfs.  Have you
>>> looked at that?
>>>
>> Thanks for the pointer...
>>
>> write_file_bool in fs/debugfs/file.c?  
>>
>> What is there is pretty much what is needed, but it's not a general
>> use function like sysfs_streq. Clearly it would make sense to use
>> what is there as a basis of such a function. 
>>
>> To save others looking it up, the relevant bit is:
>>
>> 	switch (buf[0]) {
>> 	case 'y':
>> 	case 'Y':
>> 	case '1':
>> 		*val = 1;
>> 		break;
>> 	case 'n':
>> 	case 'N':
>> 	case '0':
>> 		*val = 0;
>> 		break;
>> 	}
>>
>> There are a few cut and paste copies of this about (mostly in IIO drivers actually
>> hence why I asking if there is a better way :).
>>
>> Unless there is demand for it elsewhere I'll just add a utility function to the IIO
>> core to do this and we can revisit the case for a general function when the need
>> turns up elsewhere.
> 
> The other function that does this, and is what I was thinking of, is
> param_set_bool().  Care to merge both of these functions together into
> something "sane" and have everyone use it?
Will put out an RFC labeled patch on this and see how it goes down.

Jonathan

