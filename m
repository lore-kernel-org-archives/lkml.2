Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2GQNBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:01:35 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52401 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab2GQNBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:01:33 -0400
Message-ID: <5005623A.10808@ti.com>
Date: Tue, 17 Jul 2012 15:01:46 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0
MIME-Version: 1.0
To: Rajeev kumar <rajeev-dlh.kumar@st.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/2] MFD: twl6040: Fix revision information
References: <1342432184-12046-1-git-send-email-peter.ujfalusi@ti.com> <1342432184-12046-2-git-send-email-peter.ujfalusi@ti.com> <500508B0.9010009@st.com>
In-Reply-To: <500508B0.9010009@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 08:39 AM, Rajeev kumar wrote:
>>   #define TWL6040_REV_ES1_0        0x00
>> -#define TWL6040_REV_ES1_1        0x01
>> -#define TWL6040_REV_ES1_2        0x02
>> +#define TWL6040_REV_ES1_1        0x01 /* Rev ES1.1 and ES1.2 */
>> +#define TWL6040_REV_ES1_3        0x02
>>
>>   #define TWL6040_IRQ_TH            0
>>   #define TWL6040_IRQ_PLUG        1
>> diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
>> index a36e9fc..2786de2 100644
>> --- a/sound/soc/codecs/twl6040.c
>> +++ b/sound/soc/codecs/twl6040.c
>> @@ -653,7 +653,7 @@ int twl6040_get_hs_step_size(struct snd_soc_codec *codec)
>>   {
>>       struct twl6040 *twl6040 = codec->control_data;
>>
>> -    if (twl6040_get_revid(twl6040)<  TWL6040_REV_ES1_2)
>> +    if (twl6040_get_revid(twl6040)<  TWL6040_REV_ES1_3)
> 
> 
> Instead of doing this change why not you take a #define for revision and  do
> if (twl6040_get_revid(twl6040)<  TWL6040_REV)

ES1.1, ES1.2 of twl6040 have 2mV HS step. Newer revisions (ES1.3 of twl6040
and twl6041) have 1mV HS step.
Here the comment was correct, but the define name was incorrect.

> 
> ~Rajeev
> 
>>           /* For ES under ES_1.3 HS step is 2 mV */
>>           return 2;
>>       else
> 


-- 
Péter


