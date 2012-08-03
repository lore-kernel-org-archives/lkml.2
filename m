Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2HCJ4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:56:25 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:55069 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793Ab2HCJ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:56:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP13UBwQLs+m_aSk3Ljbktz8WrL+ZO_Tfhrt_+tRBCARyQQ@mail.gmail.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com>
 <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com> <CAPXgP13UBwQLs+m_aSk3Ljbktz8WrL+ZO_Tfhrt_+tRBCARyQQ@mail.gmail.com>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Fri, 3 Aug 2012 02:56:02 -0700
Message-ID: <CAFm5wm0nf47bcTu7iiXA3geR_5dDTF1tnf81Lz7JzbWkKdhUtA@mail.gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
To: Kay Sievers <kay@vrfy.org>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay

On Fri, Aug 3, 2012 at 2:48 AM, Kay Sievers <kay@vrfy.org> wrote:
> On Fri, Aug 3, 2012 at 11:36 AM, Pandita, Vikram <vikram.pandita@ti.com> wrote:
>> On Fri, Aug 3, 2012 at 2:32 AM, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
>
>>> As having Macro locally in the file of interest would serve the purpose,
>>> Why to change the printk code?
>>
>> As stated, the logic followed is exactly similar to well proven and
>> approved way to handle printk time stamp: CONFIG_PRINTK_TIME
>> Its an overhead on the system that enables the config option:
>> CONFIG_PRINTK_CPUID
>> Otherwise the system remains as is.
>>
>> To gain insight on SMP system logging behavior, the price to pay is
>> the extra 4 chars per printk line,
>> just like printk-time adds 15 chars to each line. Both options can be
>> disabled as desired.
>>
>> So i am not sure what kind of option you are proposing?
>> Do u imply PRINTK_TIME is not right then?
>
> It's 8 bytes per message for storing the timestamp in the records.
> There is never 15 bytes storage space needed, the prefix is
> constructed on-the-fly only while exporting the data.

When i was referring to 15 chars, its coming from here:
Its the space reserved in each line of output. Corresponding space for
cpuid is 4 chars: "[x] ":

static size_t print_time(u64 ts, char *buf)
{
        unsigned long rem_nsec;

        if (!printk_time)
                return 0;

        if (!buf)
>>>>                return 15;

>
> The CPU-ID would need at least two additional bytes (2^16 CPUS) in
> every record, unless it's a compile-time option.

are u proposing:
a) to make cpuid a u16?
b) to put cpuid in struct cont and struct log - under the #ifdef macro?

> I can't tell, if
> everybody wants to pay the storage space for the the CPU-ID feature.
>
> Kay
