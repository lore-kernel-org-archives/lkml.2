Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1DERsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:48:10 -0400
Received: from smtp.nokia.com ([147.243.128.24]:33828 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab1DERsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:48:05 -0400
Message-ID: <4D9B55C0.8040200@nokia.com>
Date: Tue, 5 Apr 2011 20:47:44 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Michal Nazarewicz <mina86@mina86.com>
CC: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb: gadget: f_mass_storage: Fix potential memory
 leak
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com> <1302017802-16614-5-git-send-email-roger.quadros@nokia.com> <op.vtg2p4fl3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vtg2p4fl3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 05 Apr 2011 17:47:46.0583 (UTC) FILETIME=[92B20270:01CBF3B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 06:59 PM, ext Michal Nazarewicz wrote:
> On Tue, 05 Apr 2011 17:36:41 +0200, Roger Quadros
> <roger.quadros@nokia.com> wrote:
> 
>> If allocation of multiple buffers would fail then we would leak memory.
>> Fix that.
>>
>> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
>> ---
>>  drivers/usb/gadget/f_mass_storage.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/f_mass_storage.c
>> b/drivers/usb/gadget/f_mass_storage.c
>> index f6bd001..60b4df9 100644
>> --- a/drivers/usb/gadget/f_mass_storage.c
>> +++ b/drivers/usb/gadget/f_mass_storage.c
>> @@ -2863,6 +2863,12 @@ buffhds_first_it:
>>          bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
>>          if (unlikely(!bh->buf)) {
>>              rc = -ENOMEM;
>> +            /* clean up */
>> +            while (i < FSG_NUM_BUFFERS) {
>> +                bh--;
>> +                kfree(bh->buf);
>> +                i++;
>> +            }
>>              goto error_release;
>>          }
>>      } while (--i);
> 
> This is handled in fsg_common_release(), isn't it?  Feel free to
> send a patch with a comment explaining that.
> 

Yes it is. This patch is not required.

-- 
regards,
-roger
