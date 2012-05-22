Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2EVIVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:21:12 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:51534 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab2EVIUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:20:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FBB4C41.8000006@cam.ac.uk>
Date: Tue, 22 May 2012 09:20:17 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: michael.hennerich@analog.com
CC: Jonathan Cameron <jic23@kernel.org>, Johan Hovold <jhovold@gmail.com>,
        Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH v4] iio: add LM3533 ambient-light-sensor driver
References: <1337100396-29024-1-git-send-email-jhovold@gmail.com> <1337346461-31220-1-git-send-email-jhovold@gmail.com> <4FB75E57.9020003@kernel.org> <20120521095010.GD21033@localhost> <4FBA6F37.4000609@kernel.org> <4FBB4415.3090908@analog.com> <4FBB4526.5030506@cam.ac.uk> <4FBB4A37.4090302@analog.com>
In-Reply-To: <4FBB4A37.4090302@analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2012 9:11 AM, Michael Hennerich wrote:
> On 05/22/2012 09:49 AM, Jonathan Cameron wrote:
>> On 5/22/2012 8:45 AM, Michael Hennerich wrote:
>>> On 05/21/2012 06:37 PM, Jonathan Cameron wrote:
>>>> Michael cc'd for comments on core support of some stuff that is also
>>>> in frequency drivers down the end of the email.
>>>>
>>>> On 05/21/2012 10:50 AM, Johan Hovold wrote:
>>>>> On Sat, May 19, 2012 at 09:48:23AM +0100, Jonathan Cameron wrote:
>>>>>> On 05/18/2012 02:07 PM, Johan Hovold wrote:
>>>>>> So to summarise, we get the following new sysfs-entries for the ALS
>>>>>> (where the first set replace targetX_Y):
>>>>>>
>>>>>> out_currentX_currentY_raw r/w, (0..255), X in 0..2, Y in 0..4
>>>>>> out_currentX_raw ro (0..255), X in 0..2
>>>>>>
>>>>>> Is there any support in core for the first set or should I simply
>>>>>> rename my target attributes?
>>>> No support in the core yet for this sort of thing..
>>>> Michael, any thoughts on this? In a sense it's very similar to
>>>> out_altvoltageX_frequencyY_raw etc...
>>>>
>>> Hi,
>>>
>>> Exactly it's similar to what we have on the DDS parts.
>>> The DDS parts would also benefit from a second index.
>>>
>>> Can someone think of an use case where we have 'differential' or
>>> 'modified'
>>> together with this pattern?
>>>
>>> If not we could use channel2 and introduce an new flag, but I fear
>>> that we end up using channel2 for too many things.
>>> So we should better introduce an new variable?
>>>
>> New variable. Tedious but channel2 is getting rather too overloaded.
>>
>>
>>
> Blah channel2 is not an option at all.
Gah. Good point.  Not enough coffee this morning...
> We need to generate an index on the postfix.
> And we can't pass this information via info_mask.
> So ext_info could be your friend?
Short term yes, though we may want more specific support for this
down the line (to make for coherent in kernel interface). Not yet
sure what form that will take though.

>

