Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0ITUCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:02:06 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:41287 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0ITUCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:02:05 -0400
In-Reply-To: <4C97BB33.5020806@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>  <1283005748-3293-2-git-send-email-rydberg@euromail.se>  <CE1C24FC-7C9A-4940-8141-391A368C59E5@enac.fr> <4C97BB33.5020806@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <6A8BB954-78BB-4507-86F3-19DA5174FA5E@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
Date: Mon, 20 Sep 2010 22:01:57 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 20 sept. 10 à 21:51, Henrik Rydberg a écrit :

> On 09/20/2010 09:46 PM, Stéphane Chatty wrote:
>
>>
>> Le 28 août 10 à 16:29, Henrik Rydberg a écrit :
>>
>>>  #define MAX_SLOTS        60
>>> -#define MAX_TRKID        59
>>> +#define MAX_TRKID        USHRT_MAX
>>>
>>
>> Oops, I forgot this one: in the rest of the code, it seems to me  
>> that you use
>> your knowledge that TRACKINGID cannot be more than 59 (you use it  
>> to map the
>> tracking ID onto the slot ID). Therefore, why change TRKID to a  
>> larger value?
>
>
> There are only 60 slots available, but an infinite number of  
> tracking ids.
> Nowhere is the tracking id assumed to be bounded by anything but  
> MAX_TRKID.
>

What about this:
+			value = clamp_val(value, 0, MAX_SLOTS - 1);
  			if (md->valid) {
  				md->curid = value;
  				md->f[value].touch = md->touch;

If you had tracking IDs 59, 60 and 61 in the same frame, this would  
not work properly would it?

St.

