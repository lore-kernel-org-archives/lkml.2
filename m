Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1DQSwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:52:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54893 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab1DQSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=swhAOz96MHn5SnvCcq89oiqcz/PgHvVoISry8NqbRIhbpwuHQ7Xt6+yc8HwYkzlyay
         z01s35JjApETNWcwldWI1Vs03PAusupibr8ss1C7l/PSDpqJ05YeHwg/Ii6CeLMubYT4
         tydXHHkNbQ0uY9KjqyeD+w4cr5e0sGKdXMD80=
Message-ID: <4DAB36D0.8080503@gmail.com>
Date: Sun, 17 Apr 2011 14:52:00 -0400
From: Jay Estabrook <jay.estabrook@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20101002)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [bug] 2.6.39-rc3 fails to boot on Alpha
References: <19883.912.266127.538215@pilspetsen.it.uu.se>
In-Reply-To: <19883.912.266127.538215@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try replacing the reference to "no_irq_chip" with "dummy_irq_chip"
in arch/alpha/irq_alpha.c: int_rtc_irq().

For me, it was dying in the first RTC interrupt taken.

Jay

On 04/17/2011 11:13 AM, Mikael Pettersson wrote:
> 2.6.39-rc3 doesn't boot on my Alpha (XP900).  As soon as aboot has loaded
> and started the kernel I get:
> 
> halted CPU 0
> 
> halt code = 4
> invalid PTBR
> PC = fffffc00003130d0
> 
> (that PC value points to an "lda" instruction in sys_osf_proplist_syscall)
> 
> There's no other output except this, so I don't think the kernel got very far.
> 
> Haven't checked 2.6.39-rc[12] or bisected anything yet, but 2.6.38 works fine.
> 
> /Mikael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-alpha" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
