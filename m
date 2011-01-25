Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1AYBXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:23:39 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1AYBXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ALjcQkoN5g44Y0BFF0Ra681VroVvG7Q/KeKtBlGoeFoY2KCvzSYtv9hatKSADQjWfF
         u+R+9of9YpefP+lDy8eA==
MIME-Version: 1.0
In-Reply-To: <20110124102647.GF16202@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-29-git-send-email-ccross@android.com>
	<20110124102647.GF16202@n2100.arm.linux.org.uk>
Date: Mon, 24 Jan 2011 17:23:30 -0800
X-Google-Sender-Auth: g37npw8bOnt_YPvmJ1l5oO_hKlI
Message-ID: <AANLkTi=Ar7dAtRHj=uZ9a+CGSaU4FhJA92+AyHoJcrcH@mail.gmail.com>
Subject: Re: [PATCH v2 28/28] ARM: tegra: clock: Add forward reference to
 struct clk
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 2:26 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jan 23, 2011 at 06:01:33PM -0800, Colin Cross wrote:
>> diff --git a/arch/arm/mach-tegra/include/mach/clkdev.h b/arch/arm/mach-tegra/include/mach/clkdev.h
>> index 412f5c6..66cd3f4 100644
>> --- a/arch/arm/mach-tegra/include/mach/clkdev.h
>> +++ b/arch/arm/mach-tegra/include/mach/clkdev.h
>> @@ -20,6 +20,8 @@
>>  #ifndef __MACH_CLKDEV_H
>>  #define __MACH_CLKDEV_H
>>
>> +struct clk;
>> +
>>  static inline int __clk_get(struct clk *clk)
>>  {
>>       return 1;
>
> If you're having to add that, I suspect this include is being
> inappropriately included by files.
>

The Tegra clock definition file, arch/arm/mach-tegra/tegra2_clocks.c,
includes the private clock.h that defines struct clk after including
linux/clkdev.h, and does not include linux/clk.h, so the forward
declaration is necessary.
