Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1DGQti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:49:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7613 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1DGQth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DjRBUuyBvx5FFw8bvR5AtA8MOuknIDzYKVBndd6+z2dxS2uV4U+iZCBr/C+ZP19pKW
         eBILeEQ9c6KRCK5sEQ7g==
MIME-Version: 1.0
In-Reply-To: <4D9D4D23.6000805@codeaurora.org>
References: <1302131890-20953-1-git-send-email-sjg@chromium.org>
	<4D9D4D23.6000805@codeaurora.org>
Date: Thu, 7 Apr 2011 09:49:33 -0700
X-Google-Sender-Auth: r3TpPtZgNf5uBo8KwMjDGTQjtWM
Message-ID: <BANLkTimaii4zNXVuUPqiWGZabRRdYM8JmQ@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: Use generic BUG() handler
From: Simon Glass <sjg@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Dave Martin <dave.martin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 10:35 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 4/6/2011 4:18 PM, Simon Glass wrote:
>> v3: Remove old BUG() implementation in favor of this one.
>> Remove the Backtrace: message (will submit this separately).
>> Use ARM_EXIT_KEEP() so that some architectures can dump exit text at link time
>> thanks to Stephen Boyd <sboyd@codeaurora.org> (although since we always
>> define GENERIC_BUG this might be academic.)
>
> Its not entirely academic because CONFIG_BUG=n and CONFIG_SMP_ON_UP=n
> would allow us to remove the exit text. This could be huge for people
> who want to cram kernel's onto space constrained devices.

OK I see. On my kernel this is 8KB but every little helps and no point
it having it in there if it isn't needed.

>> Rebase to linux-2.6.git master.
>>
>> Change-Id: I07d77c832e816f5ad2390e25f466ddf750adecf4
>
> Don't forget to remove these before submitting to the patch tracker (and
> sending to the list).

OK thanks.

>> diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
>> index 4d88425..2914724 100644
>> --- a/arch/arm/include/asm/bug.h
>> +++ b/arch/arm/include/asm/bug.h
>> @@ -3,21 +3,58 @@
>>
>>
>>  #ifdef CONFIG_BUG
>> -#ifdef CONFIG_DEBUG_BUGVERBOSE
>> -extern void __bug(const char *file, int line) __attribute__((noreturn));
>> -
>> -/* give file/line information */
>> -#define BUG()                __bug(__FILE__, __LINE__)
>
> Does anybody reference __bug() anymore? If not you can remove that too.

No one is using it now, I will do this.

Regards,
Simon
