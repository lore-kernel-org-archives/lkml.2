Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab2EXTKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab2EXTKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:10:11 -0400
Message-ID: <4FBE8790.6000000@redhat.com>
Date: Thu, 24 May 2012 21:10:08 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: pwc driver bugs
References: <4FBE4DD5.50906@xs4all.nl> <20120524165638.0ade5a6f@pyramind.ukuu.org.uk>
In-Reply-To: <20120524165638.0ade5a6f@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Thanks for adding me to the CC on this. Udo, I've
responded to your bugs in bugzilla.

Regards,

Hans


On 05/24/2012 05:56 PM, Alan Cox wrote:
> On Thu, 24 May 2012 17:03:49 +0200
> Udo van den Heuvel<udovdh@xs4all.nl>  wrote:
>
>> Hello,
>>
>> I discovered some issues in the pwc driver for certain USB webcams.
>> I opened some bugs[1].
>> I do think both issues might be related and the crash issue is quite
>> serious.
>>
>> Please have a look, I can assist by testing any patches with fixes. (for
>> ~3.3.7)
>
> commit ceede9fa8939e40ad0ddb4ad1355f45c6f1d3478
>
> looks rather relevant here.
>
> commit ceede9fa8939e40ad0ddb4ad1355f45c6f1d3478
> Author: Hans de Goede<hdegoede@redhat.com>
> Date:   Wed May 9 04:43:12 2012 -0300
>
>      [media] pwc: Fix locking
>
>      My last locking rework for pwc mistakenly assumed that videbuf2 does
>      its own locking, but it does not! This patch fixes the missing
>      locking by moving over the the video_device lock, and introducing a
>      separate lock for the videobuf2_queue.
>
>      Signed-off-by: Hans de Goede<hdegoede@redhat.com>
>      Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
