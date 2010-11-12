Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab0KLUOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:14:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40105 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab0KLUOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N5lkpeGLSt06LojS0+/vxo/pEC06h9iJIJxf/54cJthReCfmYTTQpb81IsFJkwaMcJ
         0OrGvXOyOIIk4Ro+l1aB1R4plZ1SVqDDFOfZKzpkZ4WY/S8zQJA5UJCmtsTqFI24vbQU
         4stuAajZTj+1c94af7XaKq2aV+hbxW4YpJvJI=
MIME-Version: 1.0
In-Reply-To: <20101112165420.GA6928@alchark-u3s.lan>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<20101107165745.GB1759@n2100.arm.linux.org.uk>
	<AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com>
	<20101107171726.GF1759@n2100.arm.linux.org.uk>
	<20101108171930.GA1471@alchark-u3s.lan>
	<20101111212322.GA15533@alchark-u3s.lan>
	<20101111234957.GA28735@n2100.arm.linux.org.uk>
	<20101112165420.GA6928@alchark-u3s.lan>
Date: Fri, 12 Nov 2010 23:14:12 +0300
Message-ID: <AANLkTimvMz6EJcCPjhVq5u8x3BWjCCgspbjfa0DQXJr-@mail.gmail.com>
Subject: Re: [PATCH 1/6 v6] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Russell, could you please elaborate on your comment regarding spinlocks
> and irq handlers? I always compile my kernel with all kinds of lock
> debugging, and have not run into any associated warnings. Is there
> anything suspicious specifically?

My fault: actually, those were not all lock debugging functions. It
really prints errors when lock correctness proving is enabled. I thus
decided to just assign the callback functions directly to irq_desc
struct fields, as it is done in mach-msm.

There is, however, another error showing up: it complains about my use
of ioremap inside arch_reset(). Is it fine to just hardcode the
virtual address of the respective register and use that directly in
this case? Something along the lines of:

/* PM Software Reset request register */
#define VT8500_PMSR_VIRT	0xf8130060

static inline void arch_reset(char mode, const char *cmd)
{
	writel(1, VT8500_PMSR_VIRT);
}

Thanks,
Alexey
