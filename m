Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab0IBIDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:03:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59015 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0IBID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LPe7bcOD1v1+g+X5JMwVeJkXAS2QY3Gi2q8M/1/06Ns0HwliCIgdKDLPuOag+Z7Jfq
         PGp15GZheyBkRiQFVDzS3aU8Khl2P2H9Q2IzWJEJ79IZTPMbRqNljE/y+U0qn+zeD6k3
         2ulz/tXjDFJjowCiAiXGa+z4+WZ9UNQ2SZ7oM=
Message-ID: <4C7F5A4C.5040700@gmail.com>
Date: Thu, 02 Sep 2010 10:03:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: dmitry.torokhov@gmail.com, jkosina@suse.cz, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <20100901020634.GD23585@core.coreip.homeip.net> <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu> <4C7EB3A3.7050402@gmail.com> <4C7EEBEE.5030203@seas.upenn.edu>
In-Reply-To: <4C7EEBEE.5030203@seas.upenn.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 02:12 AM, Rafi Rubin wrote:
> 
> 
> On 09/01/2010 04:12 PM, Jiri Slaby wrote:
>> On 09/01/2010 11:48 AM, Rafi Rubin wrote:
>>> --- a/drivers/hid/hid-ntrig.c
>>> +++ b/drivers/hid/hid-ntrig.c
>>> @@ -90,6 +90,26 @@ struct ntrig_data {
>>>   };
>>>
>>>
>>> +/*
>>> + * This function converts the 4 byte raw firmware code into
>>> + * a string containing 5 comma separated numbers.
>>> + */
>>> +static int ntrig_version_string(unsigned char *raw, char *buf)
>>> +{
>>> +    __u8 a =  (raw[1]&  0b00001110)>>  1;
>>> +    __u8 b =  (raw[0]&  0b00111100)>>  2;
>>> +    __u8 c = ((raw[0]&  0b00000011)<<  3) | ((raw[3]& 
>>> 0b11100000)>>  5);
>>> +    __u8 d = ((raw[3]&  0b00000111)<<  3) | ((raw[2]& 
>>> 0b11100000)>>  5);
>>> +    __u8 e =   raw[2]&  0b00000111;
>>
>> This won't compile with gcc 3.4 which we still support. Maybe time to
>> kill the support?
>>
>> ...
> 
> Why not?

Beacuse it's a gnu extension added in gcc 4.3. (I though it's in gcc 4.0
initially, but it's not. So you cannot use it in the kernel code at all.)

regards,
-- 
js
