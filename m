Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2GIOgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:36:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34134 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2GIOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAMQu2gwCXwdDmu9SdLozjC5jt7iDTqm39cY1ZZ=-VqaoF5bSvg@mail.gmail.com>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org>
	<1341826026-6504-4-git-send-email-vincent.guittot@linaro.org>
	<CAMQu2gydOEVK_fzmzkdrBwBfOq6eZG=0QfLUfFChWJu9unSn2A@mail.gmail.com>
	<CAKfTPtDPGPNk2h_zB=Rf2N2UABAgaDBbij5QFoZTxUTZJbTeAA@mail.gmail.com>
	<CAMQu2gwCXwdDmu9SdLozjC5jt7iDTqm39cY1ZZ=-VqaoF5bSvg@mail.gmail.com>
Date: Mon, 9 Jul 2012 16:36:10 +0200
Message-ID: <CAKfTPtCicLseyA4DnUwNWf7+jOmab4KLo8Yw=Rz1KPya+fE_-w@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] ARM: topology: Update cpu_power according to DT information
From: Vincent Guittot <vincent.guittot@linaro.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, a.p.zijlstra@chello.nl,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yong.zhang0@gmail.com, namhyung@kernel.org, jean.pihet@newoldbits.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2012 15:00, Shilimkar, Santosh <santosh.shilimkar@ti.com> wrote:
> On Mon, Jul 9, 2012 at 6:02 PM, Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
>> On 9 July 2012 12:55, Shilimkar, Santosh <santosh.shilimkar@ti.com> wrote:
>>> Vincent,
>>> On Mon, Jul 9, 2012 at 2:57 PM, Vincent Guittot
>>> <vincent.guittot@linaro.org> wrote:
>>>> Use cpu compatibility field and clock-frequency field of DT to
>>>> estimate the capacity of each core of the system and to update
>>>> the cpu_power field accordingly.
>>>> This patch enables to put more running tasks on big cores than
>>>> on LITTLE ones. But this patch doesn't ensure that long running
>>>> tasks will run on big cores and short ones on LITTLE cores.
>>>>
>>>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>>>> Reviewed-by: Namhyung Kim <namhyung@kernel.org>
>>>> ---
>>>>  arch/arm/kernel/topology.c |  153 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 153 insertions(+)
>>>>
>>> Sorry for not giving this comment on previous version but we should also
>>> have a way to provide the big.LITTLE information without Device Tree.
>>> May be a platform device/data.
>>
>> Hi Santosh,
>>
>> I had thought of adding such additional way to set cpu_power of
>> big.LITTLE but my conclusion was
>> -it's a new platform so it should come with DT
>> -DT is already required by other patches linked to big.LITTLE
>> (http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/080873.html)
>> -There is no device that can be easily used to get such information at
>> this early boot stage.
>>
> I see. Its new processor but it is just 1 one of the IP in an entire SOC.
> As mentioned below I was talking about full SOC support including
> all the driver subsystem with DT.
>
>>>
>>> I know we are moving DT way, but remember apart from core kernel
>>> infrastructure, to have a complete product build with DT means all the
>>> drivers must be already supporting DT which is not the case with
>>> many huge driver sub-systems like USB, display subsystem, Audio etc.
>>>
>>> Having that support would greatly help for the SOC's which have not yet
>>> reached to stage where entire SOC is DT compliant and want to use
>>> big.LITTLE infrastructure.
>>
>> Can't you support both type of devices on your platform ? You can move
>> your device to DT mode when it is supported ?
>>
> That is what eventually people end up doing who don't have
> DT ready for entire SOC. I was trying to ask whether at least some
> method is proposed(need not be merged in mainline) to have
> the big.LITTLE information parsing without DT.

Ok, IIUC, you need a temporary methods, which doesn't need to be
merged in mainline, to set the cpu_scale field ?

>
> Regards
> Santosh
