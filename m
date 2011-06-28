Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1F1JF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:05:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51744 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1F1JDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=tV0aM9kzRtqhG0d7UY9DSBGm1qg7zRwc/SZR9JhWUZPQs1iOuL/KJFGWosXxJwFolA
         TXxYiTaQrQ4qQzi7eIfIa4pT7pz1RNdX7RGsCssquA0mcgPxyCQ59Vrqy/EhdNEFX9Y7
         a1eEC95UXstzyfW7lua/RwflEQ3xFvbL21jPc=
MIME-Version: 1.0
In-Reply-To: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 28 Jun 2011 17:02:40 +0800
X-Google-Sender-Auth: SgvQySAWLcCfXao4MjGIv9o4f6M
Message-ID: <BANLkTi=1ZfWfDpUkSV0f1KoWmkJbxHg=_w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add generic idle notifiers
To: Todd Poynor <toddpoynor@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 10:46 AM, Todd Poynor <toddpoynor@google.com> wrote:
> Add notifiers for idle entry and exit, called with IDLE_START when a
> CPU goes idle and IDLE_END when it goes out of idle, based on the
> existing idle notifiers for the x86_64 arch.
>
> Convert x86_64 to use these notifiers, and call the notifiers on ARM.
>
> Convert the ARM LEDs events for idle start/end to these notifiers.
>

LinusW and I is working on consolidation LED events interface in ARM.
Please take a look at https://patchwork.kernel.org/patch/918792/

I do like to add notifiers into ledtrig-cpu driver, which can be also
shared by x86

Thanks,
-Bryan

>  arch/arm/kernel/leds.c       |   27 ++++++++++++++++++++++++++-
>  arch/arm/kernel/process.c    |    5 ++---
>  arch/x86/include/asm/idle.h  |    7 -------
>  arch/x86/kernel/process_64.c |   18 ++----------------
>  include/linux/cpu.h          |    7 +++++++
>  kernel/cpu.c                 |   20 ++++++++++++++++++++
>  6 files changed, 57 insertions(+), 27 deletions(-)
>
> --
> 1.7.3.1
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
