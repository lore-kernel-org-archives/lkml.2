Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1ERLB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:01:57 -0400
Received: from service87.mimecast.com ([94.185.240.25]:48092 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755201Ab1ERLB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:01:56 -0400
Subject: Re: [PATCH 2/2] trivial: Changed the printk loglevel when not able
 to allocate memory
From: Catalin Marinas <catalin.marinas@arm.com>
To: anish singh <anish198519851985@gmail.com>
Cc: linux@arm.linux.org.uk, lethal@linux-sh.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTinZ6d1=58Y0SCL72Jh3F6R8yfqE-Q@mail.gmail.com>
References: <1305653342.2182.15.camel@anish-desktop>
	 <BANLkTi=AGbuU-jyhqaSF+yXA3qQuKVLWfA@mail.gmail.com>
	 <BANLkTi=ngJiMyVt4AMqcWUSUM2EVXtjRQQ@mail.gmail.com>
	 <1305713710.11468.39.camel@e102109-lin.cambridge.arm.com>
	 <BANLkTinZ6d1=58Y0SCL72Jh3F6R8yfqE-Q@mail.gmail.com>
Organization: ARM Limited
Date: Wed, 18 May 2011 12:01:47 +0100
Message-ID: <1305716507.11468.68.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 18 May 2011 11:01:52.0621 (UTC) FILETIME=[FE5D91D0:01CC154A]
X-MC-Unique: 111051812015106301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 11:57 +0100, anish singh wrote:
> On Wed, May 18, 2011 at 3:45 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>         
>         On Wed, 2011-05-18 at 04:19 +0100, anish singh wrote:
>         > On Tue, May 17, 2011 at 11:13 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>         >         On 17 May 2011 18:29, anish <anish198519851985@gmail.com> wrote:
>         >         > When not able to allocate memory we were using KERN_INFO as
>         >         > log level in printk so changed to KERN_ERR
>         >         >  Signed-off-by: anish kumar<anish198519851985@gmail.com>
>         >
>         >
>         >         Maybe KERN_WARN?
>         > Then shouldn't we change below case also?
>         > 467         ret = amba_request_regions(dev, NULL);
>         > 468         if (ret) {
>         > 469                 printk(KERN_ERR "CLCD: unable to reserve regs region\n");
>         > 470                 goto out;
>         >
>         > If yes,then i will resend the patch for this also.
>         
>         
>         I think the register reserving is less likely to fail because of memory
>         allocations but more because of overlapping regions, in which case it
>         could be a programming error.
>         
>         Allocating a big framebuffer is likely to fail in some memory constraint
>         systems but I don't consider this a kernel error. That's why I suggested
>         warning.
>  
> Got it.So should i change both as KERN_WARN and resend?

No, just the one KERN_INFO one. Anyway, Russell King is the maintainer
of this driver so it's up to him to ack the patch (and don't forget to
cc him).

-- 
Catalin


