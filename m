Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2AXFY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 00:24:58 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:41780 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab2AXFY4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 00:24:56 -0500
MIME-Version: 1.0
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D034F401D296F@HQMAIL03.nvidia.com>
References: <1326925981-14723-1-git-send-email-riyer@nvidia.com>
	<4F17AE75.6000605@ti.com>
	<1FC56210173BB445BD77F608D6FB8D034F401D296F@HQMAIL03.nvidia.com>
Date: Tue, 24 Jan 2012 10:54:54 +0530
Message-ID: <CANQgH-beKYUpRigRRgzDmWajoSd7ZT_k_EaWkUax2XzqHKg8og@mail.gmail.com>
Subject: Re: [PATCH v1] Input: tegra-kbc - enable key interrupt for wakeup
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakesh,

On Thu, Jan 19, 2012 at 11:51 PM, Rakesh Iyer <riyer@nvidia.com> wrote:
>>       if (device_may_wakeup(&pdev->dev)) {
>>               disable_irq_wake(kbc->irq);
>>               tegra_kbc_setup_wakekeys(kbc, false);
>> +             /* We will use fifo interrupts for key detection. */
>> +             tegra_kbc_set_keypress_interrupt(kbc, false);
> Why do yo disable on resume why not have it enabled always?
>
>>
>>               /* Restore the resident time of continuous polling mode. */
>>               writel(kbc->cp_to_wkup_dly, kbc->mmio + KBC_TO_CNT_0);
>
> For the relevant discussion, Tegra KBC provides the following interrupts -
> a) The keypress interrupt which is generated as soon as a key is pressed,
>      before matrix scanning begins.
> b) FIFO interrupt which is generated when actual keys are decoded from the matrix,
>     and put into the FIFO.
>
> During normal operation the keypress interrupt is not useful as we have to wait for the
> keys to make it into the FIFO before reporting it to the higher layers.
>
> Since we have turned off scanning(in the following commit) we cannot use the FIFO interrupt
> during the resume, so we rely on the keypress interrupt and generate the wakeup key.
>
> Commit that turned off scanning
>
>    Input: tegra-kbc - fix wakeup from suspend
>
>    For wakeup to be reliable, kbc needs to be in interrupt mode before suspend.

Does it need to be disabled at resume?

>    Created common routine to control the FIFO interrupt.
>    Added synchronization to ensure orderly suspend.
>
>
> Regards
> Rakesh
