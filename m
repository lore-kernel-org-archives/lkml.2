Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab0G2Azu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 20:55:50 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:56600 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0G2Azs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 20:55:48 -0400
X-MXL-Hash: 4c50d194575978bb-683e9bd637320ed23e46fb0ca0989efc3f63c688
X-MXL-Hash: 4c50d19158d1e0f8-73000a0b9ca637af2cd3caa5d32428546b6f4f63
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "ss@aao.gov.au" <ss@aao.gov.au>, "gregkh@suse.de" <gregkh@suse.de>
Date: Wed, 28 Jul 2010 19:55:32 -0500
Subject: RE: [PATCH] Staging: dt3155: properly export the module parameter
Thread-Topic: [PATCH] Staging: dt3155: properly export the module parameter
Thread-Index: Acsul7unryPQX+JTTQ6L+NL2ksnxvgAILO+A
Message-ID: <0D753D10438DA54287A00B027084269763743B4D7C@AUSP01VMBX24.collaborationhost.net>
References: <201007280948.33247.hartleys@visionengravers.com>
 <4C509A18.3090607@gmail.com>
In-Reply-To: <4C509A18.3090607@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.99]
X-AnalysisOut: [v=1.0 c=1 a=eHIE_8wBqtgA:10 a=VphdPIyG4kEA:10 a=8nJEP1OIZ-]
X-AnalysisOut: [IA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=i00gxMtYAAAA:8 a=TXa]
X-AnalysisOut: [lIxSw47Pc0gzAtmwA:9 a=LCXlue5KYLOLV5AudjKDt-9VH9EA:4 a=wPN]
X-AnalysisOut: [LvfGTeEIA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 28, 2010 1:59 PM, Jiri Slaby wrote:
> On 07/28/2010 06:48 PM, H Hartley Sweeten wrote:
>> Make the module parameter dt3155_major static and add the proper
>> wrappers to export it.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: Scott Smedley <ss@aao.gov.au>
>> ---
>> 
>> diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
>> index 7316996..220eaf9 100644
>> --- a/drivers/staging/dt3155/dt3155_drv.c
>> +++ b/drivers/staging/dt3155/dt3155_drv.c
>> @@ -99,7 +99,9 @@ wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
>>  
>>  /* set to dynamicaly allocate, but it is tunable: */
>>  /* insmod DT_3155 dt3155 dt3155_major=XX */
>> -int dt3155_major = 0;
>> +static int dt3155_major;
>> +module_param(dt3155_major, int, 0);
>> +MODULE_PARM_DESC(dt3155_major, "Major device number");
>
> Is it necessary in the age of udev?
>
> I would personally get rid of that completely...

I agree but I'm not quite sure if the user space app is ready to handle that.

Scott, can you provide any input?

Regards,
Hartley