Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2HCJst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:48:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44328 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2HCJss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com> <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 3 Aug 2012 11:48:26 +0200
Message-ID: <CAPXgP13UBwQLs+m_aSk3Ljbktz8WrL+ZO_Tfhrt_+tRBCARyQQ@mail.gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 11:36 AM, Pandita, Vikram <vikram.pandita@ti.com> wrote:
> On Fri, Aug 3, 2012 at 2:32 AM, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:

>> As having Macro locally in the file of interest would serve the purpose,
>> Why to change the printk code?
>
> As stated, the logic followed is exactly similar to well proven and
> approved way to handle printk time stamp: CONFIG_PRINTK_TIME
> Its an overhead on the system that enables the config option:
> CONFIG_PRINTK_CPUID
> Otherwise the system remains as is.
>
> To gain insight on SMP system logging behavior, the price to pay is
> the extra 4 chars per printk line,
> just like printk-time adds 15 chars to each line. Both options can be
> disabled as desired.
>
> So i am not sure what kind of option you are proposing?
> Do u imply PRINTK_TIME is not right then?

It's 8 bytes per message for storing the timestamp in the records.
There is never 15 bytes storage space needed, the prefix is
constructed on-the-fly only while exporting the data.

The CPU-ID would need at least two additional bytes (2^16 CPUS) in
every record, unless it's a compile-time option. I can't tell, if
everybody wants to pay the storage space for the the CPU-ID feature.

Kay
