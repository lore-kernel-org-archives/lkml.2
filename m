Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1KNWMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:12:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43601 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab1KNWMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:12:42 -0500
Message-ID: <4EC19253.6080201@zytor.com>
Date: Mon, 14 Nov 2011 14:12:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrei Warkentin <awarkentin@vmware.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: Fix wrong error on accessing beyond valid memory
 addresses.
References: <1145760360.50519.1321308673807.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1145760360.50519.1321308673807.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 02:11 PM, Andrei Warkentin wrote:
>>
>> EOF seems wrong to me (not as bad as EFAULT, but still wrong).
>
> Although that was what we had discussed, I do not return -EOF in the patch. As you
> mention - that would be wrong. I played around with other devices (block, actually),
> and if you attempt to read(2) beyond the end, read(2) simply returns 0, as in
> zero bytes read out. Of course, lseek(2) beyond the end should return -EINVAL, as
> well, so that is what that patch I CCd you on accomplishes.
>

0 is EOF.

This is not a block device -- comparing to block devices is pointless. 
There is no "end" to /dev/mem, so this is a totally meaningless comparison.

	-hpa


