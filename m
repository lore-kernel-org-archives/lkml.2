Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0IBSBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:01:04 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:42772 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0IBSBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:01:01 -0400
Message-ID: <4C7FE63F.5010709@seas.upenn.edu>
Date: Thu, 02 Sep 2010 14:00:31 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: dmitry.torokhov@gmail.com, jkosina@suse.cz, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <20100901020634.GD23585@core.coreip.homeip.net> <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu> <4C7EB3A3.7050402@gmail.com> <4C7EEBEE.5030203@seas.upenn.edu> <4C7F5A4C.5040700@gmail.com>
In-Reply-To: <4C7F5A4C.5040700@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-02_10:2010-09-02,2010-09-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009020120
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/02/10 04:03, Jiri Slaby wrote:
> On 09/02/2010 02:12 AM, Rafi Rubin wrote:
>>
>>
>> On 09/01/2010 04:12 PM, Jiri Slaby wrote:
>>> On 09/01/2010 11:48 AM, Rafi Rubin wrote:
>>>> --- a/drivers/hid/hid-ntrig.c
>>>> +++ b/drivers/hid/hid-ntrig.c
>>>> @@ -90,6 +90,26 @@ struct ntrig_data {
>>>>   };
>>>>
>>>>
>>>> +/*
>>>> + * This function converts the 4 byte raw firmware code into
>>>> + * a string containing 5 comma separated numbers.
>>>> + */
>>>> +static int ntrig_version_string(unsigned char *raw, char *buf)
>>>> +{
>>>> +    __u8 a =  (raw[1]&  0b00001110)>>  1;
>>>> +    __u8 b =  (raw[0]&  0b00111100)>>  2;
>>>> +    __u8 c = ((raw[0]&  0b00000011)<<  3) | ((raw[3]& 
>>>> 0b11100000)>>  5);
>>>> +    __u8 d = ((raw[3]&  0b00000111)<<  3) | ((raw[2]& 
>>>> 0b11100000)>>  5);
>>>> +    __u8 e =   raw[2]&  0b00000111;
>>>
>>> This won't compile with gcc 3.4 which we still support. Maybe time to
>>> kill the support?
>>>
>>> ...
>>
>> Why not?
> 
> Beacuse it's a gnu extension added in gcc 4.3. (I though it's in gcc 4.0
> initially, but it's not. So you cannot use it in the kernel code at all.)

Sorry, would you please clarify "it".  Which bit of syntax in that code is
unsupported by the older versions of gcc?

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkx/5j8ACgkQwuRiAT9o60/uiACfTJkcLG/0m/4WQpBi82ugunc3
WY4AoIpJglKNJRm4ST1VP5nE+AiMAMJ0
=k6/0
-----END PGP SIGNATURE-----
