Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2DRH5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:57:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:33828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2DRH5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:57:04 -0400
Message-ID: <4F8E73BD.1040904@kernel.dk>
Date: Wed, 18 Apr 2012 09:56:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: James Bottomley <jbottomley@parallels.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: USB storage SCSI EH oops
References: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>  <CA+55aFyq7fp2nDGJBT+9oPTBU+uCWpp_2JBfGB3HxBSwA=5TBw@mail.gmail.com>  <CA+55aFyH-LCcDZmLhhctT2mz447aLMRShU-BOk7QnzAGGMzySA@mail.gmail.com> <1334735599.4410.17.camel@dabdike>
In-Reply-To: <1334735599.4410.17.camel@dabdike>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 09:53 AM, James Bottomley wrote:
> On Sat, 2012-04-14 at 15:49 -0700, Linus Torvalds wrote:
>> On Sat, Apr 14, 2012 at 3:29 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> Confirmed.
>>>
>>> I tested twice: with that patch, the oops is repeatable, and happens
>>> something like 30 seconds after plugging in the USB thing into the
>>> monitor.
>>>
>>> With that patch reverted, the thing still doesn't *work*, but I don't
>>> get the oops. Instead, I get the appended noise in my dmesg..
>>
>> .. and the reason that card reader has trouble seems to be that it's
>> just too damn old, and doesn't understand SD-HC cards. It works fine
>> with old SD cards.
>>
>> So the reader is fine (well, apart from being too old), USB-storage is
>> fine, but the SCSI error handler is broken.
>>
>> Even with that commit reverted, once the SCSI layer has decided to
>> off-line the device, you can't get it back, even if you remove the
>> media and insert a non-HC SD card. You have to unplug and re-plug the
>> reader. That seems to be a slight misfeature of SCSI error handling,
>> but compared to oopsing, it's minor.
> 
> OK, will either queue the update or a revert.

Martins patch went into -git 4 days ago. Since Linus didn't follow up in
rage, I was assuming the issue had been resolved with that.

-- 
Jens Axboe

