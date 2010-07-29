Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0G2QDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:03:13 -0400
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:56110 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab0G2QDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:03:11 -0400
X-MXL-Hash: 4c51a63f29d357b5-9d77ffe848f36fc27d9ea22be2fcb00ab4a6b345
X-MXL-Hash: 4c51a63c1fbb5ab0-cf24503cab3be14472ff9a3ed3270884f20aa999
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "ss@aao.gov.au" <ss@aao.gov.au>, "gregkh@suse.de" <gregkh@suse.de>
Date: Thu, 29 Jul 2010 11:02:38 -0500
Subject: RE: [PATCH] Staging: dt3155: properly export the module parameter
Thread-Topic: [PATCH] Staging: dt3155: properly export the module parameter
Thread-Index: AcsvH0yO4ulhCv8iS9acltiGXBYWuQAF3wAg
Message-ID: <0D753D10438DA54287A00B027084269763743B552E@AUSP01VMBX24.collaborationhost.net>
References: <201007280948.33247.hartleys@visionengravers.com>
 <4C509A18.3090607@gmail.com>
 <0D753D10438DA54287A00B027084269763743B4D7C@AUSP01VMBX24.collaborationhost.net>
 <4C517D80.6010106@gmail.com>
In-Reply-To: <4C517D80.6010106@gmail.com>
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
X-SOURCE-IP: [216.166.12.178]
X-AnalysisOut: [v=1.0 c=1 a=eHIE_8wBqtgA:10 a=VphdPIyG4kEA:10 a=8nJEP1OIZ-]
X-AnalysisOut: [IA:10 a=N0rcUYRaQg3G+2kUXxmxxA==:17 a=FP58Ms26AAAA:8 a=Ot4]
X-AnalysisOut: [cL13GqkpZn4jDslkA:9 a=rK4dDCXkASxzGeDihLY-ewYz7xMA:4 a=wPN]
X-AnalysisOut: [LvfGTeEIA:10 a=EHjwaH3psCHGNvmA:21 a=NghMIOCZe1bmF_JT:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 29, 2010 6:09 AM, Jiri Slaby wrote:
> On 07/29/2010 02:55 AM, H Hartley Sweeten wrote:
>> On Wednesday, July 28, 2010 1:59 PM, Jiri Slaby wrote:
>>> On 07/28/2010 06:48 PM, H Hartley Sweeten wrote:
>>>> --- a/drivers/staging/dt3155/dt3155_drv.c
>>>> +++ b/drivers/staging/dt3155/dt3155_drv.c
>>>> @@ -99,7 +99,9 @@ wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
>>>>  
>>>>  /* set to dynamicaly allocate, but it is tunable: */
>>>>  /* insmod DT_3155 dt3155 dt3155_major=XX */
>>>> -int dt3155_major = 0;
>>>> +static int dt3155_major;
>>>> +module_param(dt3155_major, int, 0);
>>>> +MODULE_PARM_DESC(dt3155_major, "Major device number");
>>>
>>> Is it necessary in the age of udev?
>>>
>>> I would personally get rid of that completely...
>> 
>> I agree but I'm not quite sure if the user space app is ready to handle that.
>
> Given it was never exposed as a parameter, applications should handle
> that. 0 means allocate major dynamically...

Understood.

I finally found the "official" site for the "DT3155 Framegrabber Linux Device Driver"

http://sourceforge.net/projects/dt3155a/

The script provided to load the module does grep /proc/devices to determine the major
device number and then mknod's the appropriate devices.

I will update my patch and remove the "parameter" since it is not needed.

Thanks,
Hartley