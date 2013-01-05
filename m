Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3AEWEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 17:04:20 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:43689 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab3AEWEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 17:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVtZg6O4e6yH_yNfGcm0dqJOp1=Mh8iN3y4GAL4vH=5QA@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
	<87k3rslg5a.fsf@xmission.com>
	<CAKocOOOXx+65rh4f8_++SwYMZdEO2FaOpLiW=dQ6uXZpwM1PYQ@mail.gmail.com>
	<CAE9FiQVpAfDb1_5TP=CqAQZQZKq=5AqQWo1NE3Sedijg+ML-gA@mail.gmail.com>
	<CAKocOONJQ3cZCdE4GDJgtk6BdnS4En+uH8H2b_dPs3naujczBg@mail.gmail.com>
	<CAE9FiQXs5mC-oCpPWNVvQgn00LVbr70NqWtgaMVU088xSkkAqg@mail.gmail.com>
	<CAKocOOMNokQ4U3RqP=O_1naP_7b97x=x44kAnXy2nc5Vofzk6Q@mail.gmail.com>
	<CAE9FiQVtZg6O4e6yH_yNfGcm0dqJOp1=Mh8iN3y4GAL4vH=5QA@mail.gmail.com>
Date: Sat, 5 Jan 2013 15:04:12 -0700
Message-ID: <CAKocOOPfzeCsvpw_H9CoT+BsZMOwsmSRFbZTKPrQf8nCzJ-wNA@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Shuah Khan <shuahkhan@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 9:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jan 4, 2013 at 6:02 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> I applied your patch to 3.6.11 and changed the panic() to pr_info()
>> and also changed enough_mem_for_swiotlb() to always return false to
>> simulate not enough memory condition as this system does have enough
>> memory.
>>
>> So at least on this AMD system, your patch will result in a panic.
>
> ok, thanks for testing.
>
> if enough_mem_for_swiotlb() return false really,  allocating buffer
> for swiotlb with bootmem would panic already, right?
>
> so this patch just delay the panic a while for AMD system with
> unhandled devices by IOMMU.
>
> Thanks
>
> Yinghai

Right. It will eventually panic. I think this is not a valid test. I
am planning to run more tests without forcing no memory condition
which is what I should have done in the first place. I will let you
know what I find, very likely Monday.

Thanks,
-- Shuah
