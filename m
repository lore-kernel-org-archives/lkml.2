Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1KHDsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:48:43 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:36401 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437Ab1KHDsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:48:42 -0500
Message-ID: <4EB8A68C.9070905@st.com>
Date: Tue, 8 Nov 2011 09:18:28 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rabin VINCENT <rabin.vincent@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] mfd/stmpe: Add support for irq over gpio pin
References: <5366f62b74861af357a0aecdb4e27aa69ffd703b.1320312035.git.viresh.kumar@st.com> <CACRpkdY=uN9W26mE7=TyXGkhcWsfOeGOyTBGQ3WzabNNHqa_-w@mail.gmail.com>
In-Reply-To: <CACRpkdY=uN9W26mE7=TyXGkhcWsfOeGOyTBGQ3WzabNNHqa_-w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/2011 5:59 PM, Linus Walleij wrote:
> On Thu, Nov 3, 2011 at 10:26 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

>> +free_gpio:
>> +       gpio_free(pdata->irq_gpio);
> 
> Will that work if you didn't request irq over GPIO?
> 
> If you did not request GPIO and stmpe_chip_init()
> fails this will still be executed.
> 
> Maybe:
> 
> if (pdata->irq_over_gpio)
>    gpio_free(pdata->irq_gpio);
> 

:(
Silly mistake.

>> diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
>> index be1af7c..7901351 100644
>> --- a/include/linux/mfd/stmpe.h
>> +++ b/include/linux/mfd/stmpe.h
>> @@ -76,6 +76,7 @@ struct stmpe {
>>        struct stmpe_variant_info *variant;
>>        const u8 *regs;
>>
>> +       int irq;
>>        int irq_base;
>>        int num_gpios;
>>        u8 ier[2];
>> @@ -194,6 +195,8 @@ struct stmpe_platform_data {
>>        unsigned int irq_trigger;
>>        bool irq_invert_polarity;
>>        bool autosleep;
>> +       bool irq_over_gpio;
>> +       int irq_gpio;
>>        int autosleep_timeout;
> 
> Please also update the kerneldoc for struct stmpe.

Sure.

-- 
viresh
