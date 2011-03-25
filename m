Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1CYVjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:39:17 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49292 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1CYVjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=T3mVLVKjWFtoBPRLb0gy0O9rNUTX7uR92gPucUdXzA0IDcAM8enbcGr6XQyeiX5i7P
         1Z4vIXGu93LB5vxz+PRMn5k2I15UlNSvWjE3gmTYOcZayDTjSeC0BTfDP6f28ZbzyL0S
         ivXwhfBaMxCBPaEb/YPiA3zOvmiHlgygxNGCQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinmwi8qa2_OFWz7o2sJoa04cK8Kod0QvpwvcBgm@mail.gmail.com>
References: <20110325133039.521553268@linutronix.de> <20110325133203.039794496@linutronix.de>
 <AANLkTinmwi8qa2_OFWz7o2sJoa04cK8Kod0QvpwvcBgm@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 17:38:55 -0400
X-Google-Sender-Auth: LFtPsXq1X0wP8VIxtBmpSril8pQ
Message-ID: <AANLkTinsfJVF0wFiyZ=D=nM6gGVnpA8h9SyeoSRcnyqm@mail.gmail.com>
Subject: Re: [patch 2/2] bfin: Convert irq namespace
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 17:34, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 09:32, Thomas Gleixner wrote:
>> -       __set_irq_handler_unlocked(irq, handle);
>> +       __irq_set_handler_locked(irq, handle);
>
> looks like a typo in your patch ?  should still be unlocked right ?

although that still doesnt fix the build failure for me ...

arch/blackfin/mach-common/ints-priority.c: In function ‘bfin_set_irq_handler’:
arch/blackfin/mach-common/ints-priority.c:562: error: implicit
declaration of function ‘__irq_set_handler_unlocked’
make[1]: *** [arch/blackfin/mach-common/ints-priority.o] Error 1
-mike
