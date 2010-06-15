Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab0FOQvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:51:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51591 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab0FOQvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YnI5Z7N3O1/5C2Xgk7OwHNdBHzExF0AnvEBIYhutSZD9MXoedzaf+tYxUaYiq1j3Y4
         PNqysk4VoaqzrNqyYRXJdFrDAt7buR88CINVKFqFAhahMUxMLdOhwHugwyy4M/VbbpWK
         OTZAU13cYAPejbc8434RYowL+KGmzRtpZ42jo=
Message-ID: <4C17AF98.3020307@gmail.com>
Date: Tue, 15 Jun 2010 09:51:36 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8]i2c:i2c_core Fix warning: variable 'dummy' set but
  not used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>	<1276547208-26569-7-git-send-email-justinmattock@gmail.com>	<20100614225315.2bae9e37@hyperion.delvare>	<4C1699C4.3010809@gmail.com> <20100615134343.6ae4a6e1@hyperion.delvare>
In-Reply-To: <20100615134343.6ae4a6e1@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:43 AM, Jean Delvare wrote:
> Hi Justin,
>
> On Mon, 14 Jun 2010 14:06:12 -0700, Justin P. Mattock wrote:
>> On 06/14/2010 01:53 PM, Jean Delvare wrote:
>>> Hi Justin,
>>>
>>> On Mon, 14 Jun 2010 13:26:46 -0700, Justin P. Mattock wrote:
>>>> could be a right solution, could be wrong
>>>> here is the warning:
>>>>     CC      drivers/i2c/i2c-core.o
>>>> drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
>>>> drivers/i2c/i2c-core.c:757:15: warning: variable 'dummy' set but not used
>>>>
>>>>    Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>
>>>> ---
>>>>    drivers/i2c/i2c-core.c |    2 ++
>>>>    1 files changed, 2 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>>>> index 1cca263..79c6c26 100644
>>>> --- a/drivers/i2c/i2c-core.c
>>>> +++ b/drivers/i2c/i2c-core.c
>>>> @@ -794,6 +794,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>>>>    	mutex_lock(&core_lock);
>>>>    	dummy = bus_for_each_drv(&i2c_bus_type, NULL, adap,
>>>>    				 __process_new_adapter);
>>>> +	if(!dummy)
>>>> +		dummy = 0;
>>>
>>> One word: scripts/checkpatch.pl
>>
>> it was this, and/or just take the code out
>> (since I'm a newbie)
>
> I was not (yet) arguing on the code itself, but on its format. Any
> patch you send should pass the formatting tests performed by
> scripts/checkpatch.pl. Thanks.
>


o.k.  I'll make sure I run everything through checkpatch.pl before 
sending anything.

Justin P. Mattock
