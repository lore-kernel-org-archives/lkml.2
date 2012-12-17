Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab2LQHP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:15:26 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61146 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2LQHPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:15:25 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-bd-50cec68a3e54
Message-id: <50CEC689.4070607@samsung.com>
Date: Mon, 17 Dec 2012 16:15:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] charger-manager: Fix bug when check dropped voltage
 after fullbatt event
References: <1353570831-19439-1-git-send-email-cw00.choi@samsung.com>
 <20121217064902.GA9027@lizard.gateway.2wire.net>
In-reply-to: <20121217064902.GA9027@lizard.gateway.2wire.net>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zLd2uY+cCDBoabC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5Ks/WQvm81TcWzSRvYFxMlcXIyeHhICJxO3nK9ghbDGJC/fW
	s3UxcnEICSxjlLhwdQsbTFFX6wtmiMR0Ron7a1YxQThdTBLth/pYQap4BbQkPpw9xARiswio
	Spy99wQszgYU3//iBtAkDg5RgQiJX/0cEOWCEj8m32MBsUUEDCQOPlwK1sosEC5xufk52EXC
	AmkSZ982gx0hJFAhMf/ba7AaTgFbiZ+/tjNC1KtLTJq3iBnClpfYvOYtM8QJAhLfJh9iAVkr
	ISArsekA2P0SAs3sEh/OfWKCeExS4uCKGywTGMVmITlpFpKxs5CMXcDIvIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjJCakdjCubLA4xCjAwajEw2uUei5AiDWxrLgy9xCjBAezkggvvztQ
	iDclsbIqtSg/vqg0J7X4EKMP0LUTmaVEk/OB8ZpXEm9obGBsaGhpaGZqaWqAQ1hJnLfZIyVA
	SCA9sSQ1OzW1ILUIZhwTB6dUA2MDdx2DqqvDHYPml7vUU6ds/+1QJvfVr6s1b3XM9Pemr2/Y
	zO5wqHvn61hX/mD+oa9btAr3n1GLUw/epXaU0ZvBMlSx4cavNs4vM6eXSaVO/yHQt+Iez4uV
	tR17cvzO2Bltn1G6zWFZad6eU3dPPeGbenU9b+7OJza7uv/8YsiO/ninKog/NlmJpTgj0VCL
	uag4EQDBqSh/tgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd2uY+cCDE7tNre4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGZOv/mQtmM9TcW/RRPYG
	xslcXYycHBICJhJdrS+YIWwxiQv31rN1MXJxCAlMZ5S4v2YVE4TTxSTRfqiPFaSKV0BL4sPZ
	Q0wgNouAqsTZe0/A4mxA8f0vbgB1c3CICkRI/OrngCgXlPgx+R4LiC0iYCBx8OFSsFZmgXCJ
	y83P2UFsYYE0ibNvm9lAbCGBCon5316D1XAK2Er8/LWdEaJeXWLSvEXMELa8xOY1b5knMArM
	QrJiFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjrhnUjsYVzZYHGIU4GBU
	4uE1Sj0XIMSaWFZcmXuIUYKDWUmEl98dKMSbklhZlVqUH19UmpNafIjRBxgAE5mlRJPzgckg
	ryTe0NjEzMjSyMzYxNzYGIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbGPA8P7SbuhLeV
	L4ROhDVO4l75/29hPafp2RqOVO2nZ6xYFwvZ77q0cGv/kagbqy40L+VLmf/rqPiKXbkFi/aK
	PIhLXvtOUKH1rIfHrqssXpWbxLuOah8J29eo+PV6oeuJdPOzU6/s0t6x0PpZ7rfyyct63l5r
	ve4h+OJIdaW13bk//Tpxkf+tlFiKMxINtZiLihMBnXtvteUCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 03:53 PM, Anton Vorontsov wrote:
> On Thu, Nov 22, 2012 at 04:53:51PM +0900, Chanwoo Choi wrote:
>> This patch check difference value between current voltage of battery
>> and desc->fullbatt_uV whether positve or negative number. If difference
>> value is negative number when current voltage of battery is larger than
>> desc->fullbatt_uV, charger-manager return immediately because battery
>> is fully charged.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/power/charger-manager.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
>> index ee039b9..17130c7 100644
>> --- a/drivers/power/charger-manager.c
>> +++ b/drivers/power/charger-manager.c
>> @@ -468,7 +468,9 @@ static void fullbatt_vchk(struct work_struct *work)
>>  	struct charger_manager *cm = container_of(dwork,
>>  			struct charger_manager, fullbatt_vchk_work);
>>  	struct charger_desc *desc = cm->desc;
>> -	int batt_uV, err, diff;
>> +	int batt_uV;
>> +	int err;
>> +	int diff;
> 
> I applied the patch, but dropped this part. This is an unrelated style
> fix, and, if anything, it desires a separate patch (possibly 'fixing' the
> whole file/driver).
> 
> Thanks!
> 

Thanks for your comment and applied it.
I will re-send other patch for fixing coding style.

Best Regards,
Chanwoo Choi
