Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2AYKPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:15:15 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38591 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2AYKPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:15:13 -0500
Date: Wed, 25 Jan 2012 11:15:12 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH] regulator: Set apply_uV only when min and max voltages are
 defined
In-reply-to: <1327483905-27007-1-git-send-email-k.lewandowsk@samsung.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com, lrg@ti.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Message-id: <4F1FD630.8070606@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1327483905-27007-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2012 10:31, Karol Lewandowski wrote:
> apply_uV is errornously set when regulator is instantiated from device
> tree, even when it doesn't contain any voltage constraints.
...
> -	if (constraints->min_uV == constraints->max_uV)
> +	if (min_uV&&  max_uV&&  constraints->min_uV == constraints->max_uV)
>   		constraints->apply_uV = true;

While this fixes obvious error I doubt that apply_uV should be set based 
on min max equality. It have required fix to fixed regulator[1]
as well for max8997[2].  It'll probably require fixes in other places too.

Wouldn't it be better to explicitly use property like 
"regulator-voltage-apply" in DT to set apply_uV?

   if (min_uV && max_uV && constraints->min_uV == constraints->max_uV
       && of_find_property "regulator-voltage-apply")
          constraints->apply_uV = true;

This would be consistent with handling of this flag from platform data.

[1] http://permalink.gmane.org/gmane.linux.kernel/1234969
[2] http://permalink.gmane.org/gmane.linux.kernel/1243714

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
