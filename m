Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0LWBjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:39:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33583 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0LWBjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vYm9fg2KuqEDJk2RftNMHhuIIauhKFnHEtFgwua9I0wKck0VSJzI93sAWb4yVoKnas
         4WbkCLOhHkhS/z1YwaoOUaGZNM/oahUXn7RbLAIChxcGPg8o8uIxyFGY2dgNCc1gu5UG
         0vyrmFQCZ/e4H4VTWMtyapaNtBf0E9MuUBMN8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1012230109150.19497@axis700.grange>
References: <Pine.LNX.4.64.1012221444300.14483@axis700.grange>
	<AANLkTim-1xCmk1S3KhdFazYCizzex0C5c_PtpjQoVkvj@mail.gmail.com>
	<Pine.LNX.4.64.1012230109150.19497@axis700.grange>
Date: Wed, 22 Dec 2010 17:39:40 -0800
X-Google-Sender-Auth: YsEtvGkAPAnRf7DrFF9qkDp6lIA
Message-ID: <AANLkTimHHOiRXek9yPwGWvFg5BWU0RF1rptuAE0ijjnW@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: provide dummy functions for DMA_ENGINE=n
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 4:13 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 22 Dec 2010, Dan Williams wrote:
>
>> On Wed, Dec 22, 2010 at 5:46 AM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > This lets drivers, optionally using the dmaengine, build with DMA_ENGINE
>> > unselected.
>> >
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> > ---
>> >  include/linux/dmaengine.h |   13 ++++++++++---
>> >  1 files changed, 10 insertions(+), 3 deletions(-)
>>
>> Is this fixing build errors, or is this just relieving drivers from
>> needing to surround calls to dma_{request|release}_channel() with
>> ifdef CONFIG_DMA_ENGINE?  The former makes this more urgent, the
>> latter can wait for the next merge window.
>
> sh_mmcif.c doesn't compile, if configured for DMA, but DMA_ENGINE is
> unselected. So, yes, this wants to be fixed. But there's more than one way
> to fix it. I've chosen this one, as it seems more generic to me.
>

Yes, it's the right fix.  I was just trying to see if it needs to go
in now and if there were any implications for -stable.  Unless I am
missing something drivers/mmc/host/sh_mmcif.c does not even include
dmaengine.h today so this can wait until the 2.6.38 window.

--
Dan
