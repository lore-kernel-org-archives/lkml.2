Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1B1PSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:18:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab1B1PSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:18:00 -0500
Message-ID: <4D6BBCA2.8030104@redhat.com>
Date: Mon, 28 Feb 2011 09:17:54 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Josef Bacik <josef@redhat.com>, Theodore Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext2/3/4: punch support?
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com>	<20110228131118.GA18193@dhcp231-156.rdu.redhat.com> <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
In-Reply-To: <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/11 8:29 AM, Dave Young wrote:
> On Mon, Feb 28, 2011 at 9:11 PM, Josef Bacik <josef@redhat.com> wrote:
>> On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
>>> Hi, josef and ext guys
>>>
>>> Do you have any plan with ext4 hole punching support? And the
>>> fallocate for ext2/3?
>>>
>>> What's the obstacle to work on this? could someone tell the status of
>>> this issue?
>>
>> There is no obstacle, just nobody has bothered to do it.  If you want to do it
>> go for it.  Thanks,
> 
> Yes, I want to do some kvm image space discard stuff,
> I use ext4 as my filesystem, but currently only xfs support something
> like trim/discard.

As Lukas said, ext4 & ext3 support various forms of trim/discard already.

But that's different from punch...

And as for fallocate on ext3, you need somewhere to put the metadata to indicate a block is allocated but not written.  This was a lot more straightforward for ext4, since it describes a large range of blocks with a single extent structure.

-Eric

> I know general knowledge about ext filesystem, but nearly new to ext4 code,
> could you give some hint where to start?
> 
> --
> Thanks
> dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

