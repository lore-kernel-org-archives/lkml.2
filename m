Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2DKH71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:59:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36699 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2DKH70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:59:26 -0400
MIME-Version: 1.0
In-Reply-To: <4F83AC55.3070900@st.com>
References: <1334004816-20219-1-git-send-email-linus.walleij@linaro.org>
	<4F83AC55.3070900@st.com>
Date: Wed, 11 Apr 2012 09:59:25 +0200
Message-ID: <CACRpkdaz9g7cRc1rAMHUzRbLcrYtB-kPCB6bFEMYZxxmWfLNSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma/amba-pl08x: add support for the Nomadik variant
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 5:43 AM, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 4/10/2012 2:23 AM, Linus Walleij wrote:

>> +                     val = readl(ch->base + PL080_CH_CONFIG);
>> +                     if (val & (PL080N_CONFIG_ITPROT | PL080N_CONFIG_SECPROT)) {
>> +                             dev_info(&adev->dev, "physical channel %d reserved "
>> +                                      "for secure access only\n", i);
>
> Better not to break the print string. Go beyond 80 columns.

OK

>> +                             ch->locked = true;
>> +                     } else
>> +                             ch->locked = false;
>> +             }
>> +
>
> Memory for ch is allocated with kmalloc and so its default value is garbage.
> So we must set locked to false in else part here.

Hm maybe better to kzalloc() the channel structs?

>> @@ -2036,9 +2069,9 @@ static struct amba_id pl08x_ids[] = {
>>       },
>>       /* Nomadik 8815 PL080 variant */
>>       {
>> -             .id     = 0x00280880,
>> +             .id     = 0x00280080,
>
> Has this changed? How it worked earlier?

Never worked until now. It was based on incorrect data sheets...

I'll send a V2 ASAP.

Yours,
Linus Walleij
