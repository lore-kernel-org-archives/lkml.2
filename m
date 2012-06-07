Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab2FGX0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:26:16 -0400
Received: from masquerade.micron.com ([137.201.242.130]:44095 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab2FGX0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:26:14 -0400
Message-ID: <4FD13890.7020203@micron.com>
Date: Thu, 7 Jun 2012 16:26:08 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 1/2] mtip32xx: Remove 'registers' and 'flags' from sysfs
References: <4FCD0FC7.9010105@micron.com> <20120605093314.GC21560@kroah.com> <4FCE4D67.1030309@micron.com> <20120605202555.GA4727@kroah.com> <4FCF9BA1.90308@micron.com> <20120606212554.GA17852@kroah.com>
In-Reply-To: <20120606212554.GA17852@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18952.004
X-TM-AS-Result: No--23.256900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2012 2:25 PM, Greg KH wrote:

> On Wed, Jun 06, 2012 at 11:04:17AM -0700, Asai Thambi S P wrote:
>> On 6/5/2012 1:25 PM, Greg KH wrote:
>>
>>> On Tue, Jun 05, 2012 at 11:18:15AM -0700, Asai Thambi S P wrote:
>>>> On 6/5/2012 2:33 AM, Greg KH wrote:
>>>>
>>>>> On Mon, Jun 04, 2012 at 12:43:03PM -0700, Asai Thambi S P wrote:
>>>>>>
>>>>>> This patch removes entries 'registers' and 'flags' from sysfs. Updated ABI file
>>>>>> to reflect this change.
>>>>>>
>>>>>> Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
>>>>>
>>>>> Much nicer, thanks for doing this:
>>>>>
>>>>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>
>>>>> But, one question on a different sysfs file:
>>>>>
>>>>>>  What:           /sys/block/rssd*/status
>>>>>>  Date:           April 2012
>>>>>>  KernelVersion:  3.4
>>>>>>  Contact:        Asai Thambi S P <asamymuthupa@micron.com>
>>>>>>  Description:    This is a read-only file. Indicates the status of the device.
>>>>>
>>>>> What "status" is this showing?  Why is this a sysfs file?  Who
>>>>> needs/wants it?
>>>>
>>>>
>>>> This shows the device status - online, write_protect or thermal_shutdown. This
>>>> would be used by management application.
>>>
>>> Is it used by a management application?  Shouldn't such a tool use the
>>> "standard" block device status files instead?  I thought we exported
>>> that information already in the /sys/block/* files.
>>>
>>
>>
>> device status is not exported by standard block interface.
> 
> Ok, but don't you think it should be?  Why make this unique to only your
> driver?
> 


It is unique to our driver because it exports information that is unique. In
addition to write protect and thermal status, in future it would export the
status of what we call “ftl rebuild”, which is a rebuilding of the logical to
physical mappings internal to the flash controller. If and when other devices
need to export device status, it could be moved to standard block interface.

--
Regards,
Asai Thambi

