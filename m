Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab1DMPWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:22:10 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54963 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757130Ab1DMPWI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KYXBhRu4smboM0je4bEso4O56OcmT5PwcsxiKLHuPHWikI+SwDHpvZCx+81McYq5ZR
         pSFwMgyYF0AXGO3sY3BGiUtAb5hBNUXns3qbQedp+q3UFjX86TGhoIFIU/zHXwOn267q
         Vo9Trprpae33XOtzIu2UNJJRZ46JGI3I12ifk=
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C8B3C9F@dbde02.ent.ti.com>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
	<f1ff3f2888725a1e03541e0be5c0880f0591aea2.1302031487.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB593024C8B3C9F@dbde02.ent.ti.com>
Date: Wed, 13 Apr 2011 11:22:05 -0400
Message-ID: <BANLkTi=j=Dp015ZsU44DH3p1s_XdxvAX8Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] da8xx: enable the use of the ICPFUNC in i2c-davinci
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        "Griffis, Brad" <bgriffis@ti.com>,
        Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Wed, Apr 13, 2011 at 11:10 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> Hi Ben,
>
> On Wed, Apr 06, 2011 at 03:08:09, Ben Gardiner wrote:
>> Both the da850 and da830 have an I2C controller which has the ICPFUNC
>> registers. Indicate this for all da830 and da850 boards by setting the
>> has_pfunc flag true in the da8xx utility setup routine for registering the
>> I2C controller
>>
>> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>>
>> ---
>>  arch/arm/mach-davinci/devices-da8xx.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
>> index beda8a4..da01558 100644
>> --- a/arch/arm/mach-davinci/devices-da8xx.c
>> +++ b/arch/arm/mach-davinci/devices-da8xx.c
>> @@ -324,6 +324,12 @@ int __init da8xx_register_i2c(int instance,
>>       else
>>               return -EINVAL;
>>
>> +     /*
>> +      * Both the DA850 and DA830 have an I2C controller which has the
>> +      * ICPFUNC et. al. registers
>> +      */
>> +     pdata->has_pfunc = 1;
>
> The I2C driver implements a default platform data
> so it should actually be legal for a DA8x board to
> pass NULL platform data. In that case this line
> will crash.

Good catch, thanks.

> [...] You should either check for pdata to
> be NULL or just let each board choose whether it
> needs recovery (I think the better option).

I understand "check for pdata to be NULL."  If you think it is the
better option I'd be happy to implement it but I don't understand how
to implement "let each board choose whether it needs recovery."

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
