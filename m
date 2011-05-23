Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1EWFSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:18:06 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6875 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1EWFSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pUkRrIVZeD0aiOHJz1smw9YKS8pC6ZXe8Lo3dtrj4rUR0vNazvtQ1VZDklQXCty/k/
         DjeIFPU21Rgm8X8UhWkQ==
MIME-Version: 1.0
In-Reply-To: <4DD75BC9.8040004@ti.com>
References: <1305851091-10096-1-git-send-email-ccross@android.com>
	<4DD75BC9.8040004@ti.com>
Date: Sun, 22 May 2011 22:18:01 -0700
X-Google-Sender-Auth: hpgjmXMJz9z9X7sKC5UUmioA_xc
Message-ID: <BANLkTikyGFVKTst1xJTGzHuwY_2GoG6NOw@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: smp_twd: Reconfigure clockevents after cpufreq change
From: Colin Cross <ccross@android.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 11:29 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On 5/20/2011 5:54 AM, Colin Cross wrote:
>>
>> The localtimer's clock changes with the cpu clock.  After a
>> cpufreq transition, update the clockevent's frequency and
>> reprogram the next clock event.
>>
>> Adds a clock called "smp_twd" that is used to determine the
>> twd frequency, which can also be used at init time to
>> avoid calibrating the twd frequency.
>>
>> Clock changes are based on Rob Herring's work.
>>
>> Change-Id: I413b5cd07fb2b79bc9fad8b4bf257332d1da7bcd
>> Signed-off-by: Colin Cross<ccross@android.com>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Russell King<linux@arm.linux.org.uk>
>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Rob Herring<robherring2@gmail.com>
>> Tested-by: Linus Walleij<linus.walleij@linaro.org>
>> ---
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
> What about the clock-node patches?
> Do you want those to get merged via sub-arch tree's once this
> patch + Thomas's new API gets merged ?

The clock-node patches can be merged independently - twd scaling just
won't work until they are both merged.
