Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1ATM0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:26:50 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:39885 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1ATM0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:26:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=a0vyZBYU8hwGGUoHd8LMkJvrhCmmBi1HAG1iGLJ/xHp6o3tuAUBPbT5NtaqEhS510/
         zWxwzoBXziETt7vvla8HNc87KF1NjCr/2tCkGImNRztP7Ngq5mdKQkR3Xou+L4ta4C8u
         9FjRFFxcrwXkJxkNkOS/jWtpwGHn6xX+U4Dnw=
Message-ID: <4D3829E7.9050305@gmail.com>
Date: Thu, 20 Jan 2011 20:26:15 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Josef Bacik <josef@redhat.com>, strongzgy <strongzgy@gmail.com>,
        onlyflyer <onlyflyer@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, ak <ak@linux.intel.com>,
        akpm <akpm@linux-foundation.org>, miaox <miaox@cn.fujitsu.com>,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        meego-kernel <meego-kernel@meego.com>
Subject: Re: [PATCH] Avoid a NULL pointer in btrfs
References: <4D36F04D.70505@gmail.com> <20110119141334.GA2544@localhost.localdomain> <1295452288-sup-8924@think>
In-Reply-To: <1295452288-sup-8924@think>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011-1-19 23:52, Chris Mason 写道:
> Excerpts from Josef Bacik's message of 2011-01-19 09:14:02 -0500:
>> On Wed, Jan 19, 2011 at 10:08:13PM +0800, Liuwenyi wrote:
>>> In Yang Ruirui's mail, the btrfs will create a oops. This is caused by a
>>> null pointer in test_range_bit() while lock the spinlock.
>>>
>>> So, It is necessary to add a pointer check into test_range_bit()
>>>
>>
>> NAK, the tree shouldn't be null coming into this function, something else is
>> going wrong.  What oops is this?  Thanks,
The mail is here http://lkml.org/lkml/2011/1/19/24

another mesg is here http://www.aei.mpg.de/~crmafra/dmesg-2.6.35.3.txt
> What was your metadata blocksize for this oops?  This call should never
> happen.
It is rare and hard to reproduced. So, I update this patch, just avoid a 
null pointer calling.
> I think there is a larger problem, probably in the IO error handling
> code since the trace had io errors beforehand.
Yes, I agree. This situation is too strange to happen.
> -chris
---
Best Regards,
Liu Wenyi
