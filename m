Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2ATXzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:55:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2ATXzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:55:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAHGf_=o4PcPh3bJU8gFzGXtKeXCkdmrvfOZ2nUDc_epf1tnNyA@mail.gmail.com>
References: <4F171B6B.2040303@gmail.com>
	<1327003271-11730-1-git-send-email-venki@google.com>
	<4F18805F.8060901@linux.vnet.ibm.com>
	<CABeCy1YcP1u65CU8n8ug4g7haUq8Vyi55ABZr3hNHFxu429x+w@mail.gmail.com>
	<CAHGf_=o4PcPh3bJU8gFzGXtKeXCkdmrvfOZ2nUDc_epf1tnNyA@mail.gmail.com>
Date: Fri, 20 Jan 2012 15:55:36 -0800
Message-ID: <CABeCy1aWv1DmqrkbBJ=JmAK7UkSLH+yPK-EG+58_573yG3jsHg@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
From: Venki Pallipadi <venki@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 3:45 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>>>> +int nr_online_cpus __read_mostly;
>>>> +EXPORT_SYMBOL(nr_online_cpus);
>>>> +
>>>>  void set_cpu_possible(unsigned int cpu, bool possible)
>>>>  {
>>>>       if (possible)
>>>
>>>
>>> Did you forget to add:
>>>
>>>        nr_possible_cpus = cpumask_weight(cpu_possible_mask);
>>>
>>> inside set_cpu_possible() ?
>>
>> No. That was intentional as I have that coupled with nr_cpu_ids and
>> set once after all the bits are set in setup_nr_cpu_ids() instead of
>> doing for each bit set.
>
> But, Srivatsa's way seems more safer, no? Is there any advantage to make couple
> with nr_cpu_ids?

I think it is a tradeoff between safer and cleaner :). infact, that's
how I had coded the patch first. But, then I changed it to be in sync
with nr_cpu_ids as it seemed a bit cleaner (and also to make sure 2048
CPU guys won't come after me for doing the mask calculation 2048 times
during the boot).
