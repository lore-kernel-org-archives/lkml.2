Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0EaS5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:57:15 -0400
Received: from mail.virtall.com ([178.63.195.102]:43664 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893Ab0EaS5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:57:14 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 May 2010 14:57:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=wpkg.org; h=message-id:date
	:from:mime-version:to:cc:subject:content-type
	:content-transfer-encoding; q=dns; s=default; b=Vzy2//120efCTpMA
	VS+6zn02hhblG4XYhWmeulfNj6GcrmNCK7IYUHBnkyuAwuOn5jCowlxqNwSjryKK
	8gb6VSLZWNCbh0gUg4A26H3N0QO4YsdWcZntu95uN4q2Vsntprqcc4m9UWFStdqi
	6xhyYZcvXqF+PtQhB82UfTdqoBM=
Message-ID: <4C040441.9020107@wpkg.org>
Date: Mon, 31 May 2010 20:47:29 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100525 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mbroz@redhat.com, Andi Kleen <andi@firstfloor.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz wrote:

> On 05/31/2010 06:04 PM, Andi Kleen wrote:
>> DM-CRYPT: Scale to multiple CPUs
>>
>> Currently dm-crypt does all encryption work per dmcrypt mapping in a
>> single workqueue. This does not scale well when multiple CPUs
>> are submitting IO at a high rate. The single CPU running the single
>> thread cannot keep up with the encryption and encrypted IO performance
>> tanks.
>
> This is true only if encryption run on the CPU synchronously.
>
> (Usually it is high speed SSD or dm-crypt above striped RAID where
> underlying device throughput is higher than CPU encryption speed.)

Quite common to hit on a netbook/laptop with encrypted root these days, 
where storage can be relatively fast when compared to the speed of one 
of the cores of the (usually) multicore CPU.


-- 
Tomasz Chmielewski
http://wpkg.org

