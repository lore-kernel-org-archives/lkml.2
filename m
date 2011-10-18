Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab1JRMpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:45:17 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:34745 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab1JRMpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:45:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9D74DA.1000208@cam.ac.uk>
Date: Tue, 18 Oct 2011 13:45:14 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] input/cma3000_d0x: Keep configuration on poweroff
References: <1318926486-10330-1-git-send-email-ricardo.ribalda@gmail.com> <1318926486-10330-4-git-send-email-ricardo.ribalda@gmail.com> <4E9D3A45.1040103@cam.ac.uk> <CAPybu_1JsTTOn5wP53Qd-jm+JhgwUTLhRb4BPjKaMab6174CNQ@mail.gmail.com>
In-Reply-To: <CAPybu_1JsTTOn5wP53Qd-jm+JhgwUTLhRb4BPjKaMab6174CNQ@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 13:07, Ricardo Ribalda Delgado wrote:
> On Tue, Oct 18, 2011 at 10:35, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>> On 10/18/11 09:28, Ricardo Ribalda Delgado wrote:
>>> When the device goes to poweroff keep the spi/i2c configuration.
>>> Otherwhise the device could not wake up if it was in spi mode.
>>>
>> Run checkpatch.pl over these
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> 
> I did :(
> 
> ricardo@newpili:~/hacking/linux$ scripts/checkpatch.pl
> cmr_patches/v1/0003-input-cma3000_d0x-Keep-configuration-on-poweroff.patch
> total: 0 errors, 0 warnings, 19 lines checked
> 
> cmr_patches/v1/0003-input-cma3000_d0x-Keep-configuration-on-poweroff.patch
> has no obvious style problems and is ready for submission.
> 
> But I fix that right away
Curious.  checkpatch seems to be getting more flexible...  I just assumed
it would pick those issues up!
> 
> 
>>> ---
>>>  drivers/input/misc/cma3000_d0x.c |    6 +++++-
>>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
>>> index 9899742..15577b7 100644
>>> --- a/drivers/input/misc/cma3000_d0x.c
>>> +++ b/drivers/input/misc/cma3000_d0x.c
>>> @@ -44,6 +44,7 @@
>>>  #define CMA3000_RANGE2G    (1 << 7)
>>>  #define CMA3000_RANGE8G    (0 << 7)
>>>  #define CMA3000_BUSI2C     (0 << 4)
>>> +#define CMA3000_BUSSPI     (1 << 4)
>>>  #define CMA3000_MODEMASK   (7 << 1)
>>>  #define CMA3000_GRANGEMASK (1 << 7)
>>>
>>> @@ -230,8 +231,11 @@ static int cma3000_poweron(struct cma3000_accl_data *data)
>>>  static int cma3000_poweroff(struct cma3000_accl_data *data)
>>>  {
>>>       int ret;
>>> +     u8 ctrl = CMAMODE_POFF;
>>>
>>> -     ret = CMA3000_SET(data, CMA3000_CTRL, CMAMODE_POFF, "Mode setting");
>>> +     ctrl |= data->bus_ops->ctrl_mod;
>>> +
>>> +     ret = CMA3000_SET(data, CMA3000_CTRL , ctrl, "Mode setting");
>> no space before comma.
>>>       msleep(CMA3000_SETDELAY);
>>>
>>>       return ret;
>>
>>
> 
> 
> 

