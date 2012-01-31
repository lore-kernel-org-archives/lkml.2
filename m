Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2AaPBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:01:14 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55522 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368Ab2AaPBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:01:13 -0500
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de> <1327960820-11867-9-git-send-email-danny.kukawka@bisect.de> <201201311445.27230.danny.kukawka@bisect.de>
User-Agent: K-9 Mail for Android
In-Reply-To: <201201311445.27230.danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 08/16] ivtv-driver: fix handling of 'radio' module parameter
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 31 Jan 2012 10:00:31 -0500
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mchehab@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <88b53197-44ea-4949-9758-534fad5d8a71@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-31_05:2012-01-31,2012-01-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1201310082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Danny Kukawka <danny.kukawka@bisect.de> wrote:

>On Dienstag, 31. Januar 2012, Andy Walls wrote:
>> On Mon, 2012-01-30 at 20:40 +0100, Danny Kukawka wrote:
>> > Fixed handling of 'radio' module parameter from module_param_array
>> > to module_param_named to fix these compiler warnings in
>ivtv-driver.c:
>> >
>> > In function ‘__check_radio’:
>> > 113:1: warning: return from incompatible pointer type [enabled by
>> > default] At top level:
>> > 113:1: warning: initialization from incompatible pointer type
>[enabled by
>> > default] 113:1: warning: (near initialization for
>> > ‘__param_arr_radio.num’) [enabled by default]
>> >
>> > Set initial state of radio_c to true instead of 1.
>>
>> NACK.
>>
>> "radio" is an array of tristate values (-1, 0, 1) per installed card:
>>
>> 	static int radio[IVTV_MAX_CARDS] = { -1, -1,
>>
>> and must remain an array or you will break the driver.
>>
>> Calling "radio_c" a module parameter named "radio" is wrong.
>>
>> The correct fix is to reverse Rusty Russel's patch to the driver in
>> commit  90ab5ee94171b3e28de6bb42ee30b527014e0be7
>> to change the "bool" to an "int" as it should be in
>> "module_param_array(radio, ...)"
>
>Overseen this. But wouldn't be the correct fix in this case to:
>a) reverse the part of 90ab5ee94171b3e28de6bb42ee30b527014e0be7 to get:
>   static unsigned int radio_c = 1;
>
>b) change the following line:
>   module_param_array(radio, bool, &radio_c, 0644);
>   to:
>   module_param_array(radio, int, &radio_c, 0644);
>
>Without b) you would get a warning from the compiler again.
>
>Danny 

Yes both need to happen.

I mentioned b) in my original email.

Regards,
Andy
