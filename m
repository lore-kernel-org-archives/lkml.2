Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1HYTsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:48:15 -0400
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:38232 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab1HYTsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:48:14 -0400
Message-ID: <4E56A6D7.2060603@fastmail.fm>
Date: Thu, 25 Aug 2011 21:47:35 +0200
From: anders eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110813 Thunderbird/5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: mtrr failure, 3.1-rc1
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org> <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com> <20110825164649.GL2803@mtj.dyndns.org>
In-Reply-To: <20110825164649.GL2803@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.233.92
X-Scan-Result: No virus found in message 1Qwfu3-0007r5-IP.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1Qwfu3-0007r5-IP 2afb67a05b9e102a53bbdc1ea0a70958
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-25 18:46, Tejun Heo wrote:
> Anders, if your kernel didn't have SMP turned on, can you please
> verify the following patch fixes the problem?
>
> Thanks.
>
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index 08119a3..6b96110 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -149,7 +149,6 @@ struct set_mtrr_data {
>    */
>   static int mtrr_rendezvous_handler(void *info)
>   {
> -#ifdef CONFIG_SMP
>   	struct set_mtrr_data *data = info;
>
>   	/*
> @@ -171,7 +170,6 @@ static int mtrr_rendezvous_handler(void *info)
>   	} else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
>   		mtrr_if->set_all();
>   	}
> -#endif
>   	return 0;
>   }
>
Tested. Works as expected. Thanks!

-A
