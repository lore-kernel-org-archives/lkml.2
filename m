Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2FRNaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:30:16 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:36978 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290Ab2FRNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:30:14 -0400
Message-ID: <4FDF2D58.9010006@ti.com>
Date: Mon, 18 Jun 2012 19:00:00 +0530
From: a0393909 <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>
Subject: Re: [linux-pm] cpuidle future and improvements
References: <4FDEE98D.7010802@linaro.org>
In-Reply-To: <4FDEE98D.7010802@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On 06/18/2012 02:10 PM, Daniel Lezcano wrote:
>
> Dear all,
>
> A few weeks ago, Peter De Schrijver proposed a patch [1] to allow per
> cpu latencies. We had a discussion about this patchset because it
> reverse the modifications Deepthi did some months ago [2] and we may
> want to provide a different implementation.
>
> The Linaro Connect [3] event bring us the opportunity to meet people
> involved in the power management and the cpuidle area for different SoC.
>
> With the Tegra3 and big.LITTLE architecture, making per cpu latencies
> for cpuidle is vital.
>
> Also, the SoC vendors would like to have the ability to tune their cpu
> latencies through the device tree.
>
> We agreed in the following steps:
>
> 1. factor out / cleanup the cpuidle code as much as possible
> 2. better sharing of code amongst SoC idle drivers by moving common bits
> to core code
> 3. make the cpuidle_state structure contain only data
> 4. add a API to register latencies per cpu
>
> These four steps impacts all the architecture. I began the factor out
> code / cleanup [4] and that has been accepted upstream and I proposed
> some modifications [5] but I had a very few answers.
>
Another thing which we discussed is bringing the CPU cluster/package
notion in the core idle code. Couple idle did bring that idea to some
extent but in can be further extended and absratcted. Atm, most of
the work is done in back-end cpuidle drivers which can be easily
abstracted if the "cluster idle" notion is supported in the core layer.

Per CPU __and__ per operating point(OPP), latency is something which
can be also added to the list. From the discussion I remember, it
matters for few SoCs and can be beneficial.

Regards
Santosh
