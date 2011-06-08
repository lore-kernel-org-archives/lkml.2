Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1FHVwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:52:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59113 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1FHVwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=u4qEOF84Srs2HjXpaybgc+Kf7WgdEGCsd6TCJRn+09KaU3Ei8TQ6ACk33Er5NVa87F
         ehtr5KgslS45uNA9OTiZj66+TFgxvvgvbEz7R6SANYhjVaCS7n2QQllJcnEqpJQdpCch
         KzUvXDFeTFZQiWM8ztuc55rh88UvTn4SZZkyA=
MIME-Version: 1.0
In-Reply-To: <20110608204127.GC13151@n2100.arm.linux.org.uk>
References: <BANLkTin7mqqTsosPHbztaPfL7s_TUGT1qg@mail.gmail.com>
	<20110608142121T.fujita.tomonori@lab.ntt.co.jp>
	<BANLkTi=FcNncT_6HpvB_6OnQ94f0_sz7Gw@mail.gmail.com>
	<20110608160844E.fujita.tomonori@lab.ntt.co.jp>
	<BANLkTikFKr+3Qph+CR40SUV-DCir1v=KBg@mail.gmail.com>
	<20110608204127.GC13151@n2100.arm.linux.org.uk>
Date: Wed, 8 Jun 2011 14:52:17 -0700
X-Google-Sender-Auth: 32TsxIrQA2bq_gfvjFLpp3oInSM
Message-ID: <BANLkTi=Z7gXjEAPrdkF1x34Y5KzMH67aVA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for max_segment_number
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, cjb@laptop.org,
        patches@linaro.org, vinod.koul@intel.com, gregkh@suse.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 1:41 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jun 08, 2011 at 01:05:57PM -0700, Dan Williams wrote:
>> Even if that were the case it would be same situation that the scsi device
>> driver reports maximum parameters, but the subsystem opts for
>> something tighter.  Whether the maximal parameters come from the scsi
>> device or the dma channel is moot.
>
> Except for the small issue that many DMA-engine using devices do not
> have _any_ DMA capabilities of their own, which means they don't have
> anything to put in their own struct device's DMA parameters.  We can't
> go around making up random insane parameters in the hope that they'll
> exceed whatever DMA-engine is being used with the device - that's a
> hack not a solution.

So, I was operating under the assumption that most dmaengine drivers
would ignore this api, it's just useful to the subset of slave-dma
consumers that have apriori knowledge that the best answer for the dma
geometry comes from the channel.  But not sure how we prevent abuse of
this api for cases where a better answer is available from another
source, which I think is what Tomonori-san is worried about.
