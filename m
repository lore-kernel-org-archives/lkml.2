Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2HNJIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:08:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15877 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2HNJIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:08:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 14 Aug 2012 02:08:33 -0700
Message-ID: <502A11A0.7070906@nvidia.com>
Date: Tue, 14 Aug 2012 14:21:44 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: "regulator: Enable supply regulator if child rail is enabled"
 broken?
References: <CAH+eYFAJ0FSiZoDiyYJsEg1j-cAhG7DkCwFNJGe5vBNpiUM7ug@mail.gmail.com>
In-Reply-To: <CAH+eYFAJ0FSiZoDiyYJsEg1j-cAhG7DkCwFNJGe5vBNpiUM7ug@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012 02:08 PM, Rabin Vincent wrote:
> It appears that this patch causes incorrect reference counting on supply
> regulators if the child regulator is enabled with for example boot_on=true:
>
> commit b2296bd43e781976743354c668a356b0df98e1da
> Author: Laxman Dewangan<ldewangan@nvidia.com>
> Date:   Mon Jan 2 13:08:45 2012 +0530
>
>      regulator: Enable supply regulator if child rail is enabled.
>
> If a regulator is enabled at boot (by constraints), then this patch calls
> regulator_enable() on the supply regulator, leading to a use_count increase on
> the supply.  However, this patch adds no code to perform the corresponding
> regulator_disable(), leaving the supply regulator on even when all consumers
> have disabled it.
>
> AFAICS, this patch would have only worked for always_on regulators.

Yaah, It is missing the regulator_disable() in regulator_init_complete() 
for some cases.
Please let me know if I need to send patch for fixing this issue.

