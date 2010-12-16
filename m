Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0LPMzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:55:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43448 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0LPMz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:55:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oSRDJQEslXJ7Ba/KhIoQvdgobfjpJJ/K6NWe5OUWyYsNm59N57uqJ5gcRPfydZPvOt
         FwqPc0rkUUEIOpTLzjbhdXubjRShJtGPvRJjHj/iQONfNLQN+Cn8z6i/4dKiOGoHf3R5
         7DZHL/3OhQq77DP9iBI7m7eOdMmT+H6Qef4v8=
MIME-Version: 1.0
In-Reply-To: <1292482456-22690-5-git-send-email-johlstei@codeaurora.org>
References: <1292482456-22690-1-git-send-email-johlstei@codeaurora.org>
	<1292482456-22690-5-git-send-email-johlstei@codeaurora.org>
Date: Thu, 16 Dec 2010 12:55:28 +0000
X-Google-Sender-Auth: 4hFF7ACpxhoFtNWEx8SvGbUDt0w
Message-ID: <AANLkTinzVP4rjOZM0PZQGYBNm+z-O=S0h6vo1QVoh+ps@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] msm: hotplug: support cpu hotplug on msm
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2010 06:54, Jeff Ohlstein <johlstei@codeaurora.org> wrote:
> --- /dev/null
> +++ b/arch/arm/mach-msm/hotplug.c
[...]
> +static inline void platform_do_lowpower(unsigned int cpu)
> +{
> +       /* Just enter wfi for now. TODO: Properly shut off the cpu. */
> +       for (;;) {
> +               /*
> +                * here's the WFI
> +                */
> +               asm(".word      0xe320f003\n"
> +                   :
> +                   :
> +                   : "memory", "cc");

Is this for an ARMv7 platform? If yes, you could just use the WFI
instruction directly (and it would also work if compiling the kernel
to Thumb-2 mode).

-- 
Catalin
