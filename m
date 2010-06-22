Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab0FVMkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 08:40:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37584 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162Ab0FVMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 08:40:22 -0400
Subject: Re: [PATCH] kmemleak: config-options: Default buffer size for
 kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>, Sankar P <sankar.curiosity@gmail.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       lrodriguez@atheros.com, rnagarajan@novell.com, teheo@novell.com,
       linux-mm@kvack.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       akpm@linux-foundation.org
In-Reply-To: <AANLkTin9ssqksoAvafRdsogmfrDUhShHCF9aCUb7CtCl@mail.gmail.com>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
	 <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
	 <4C20702C.1080405@cs.helsinki.fi>
	 <1277196403-20836-1-git-send-email-sankar.curiosity@gmail.com>
	 <20100622113135.GB20140@linux-sh.org>
	 <1277208351.29532.5.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTin9ssqksoAvafRdsogmfrDUhShHCF9aCUb7CtCl@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 22 Jun 2010 13:35:04 +0100
Message-ID: <1277210104.29532.13.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2010 12:35:05.0055 (UTC) FILETIME=[5765C6F0:01CB1207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 13:21 +0100, Pekka Enberg wrote:
> On Tue, Jun 22, 2010 at 3:05 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > The defconfig change for this specific platform may be a better option
> > but I thought defconfigs are to provide a stable (and maybe close to
> > optimal) configuration without all the debugging features enabled
> > (especially those slowing things down considerably).
> 
> The defconfig change was definitely not a clean solution to this
> problem. Better bake the fix in Kconfig proper even if it means
> dependency on CONFIG_SH or something.

OK, maybe something like this

	default 1000 if SH
	default 400

It seems that kbuild only considers the first encounter of "default".

Thanks.

-- 
Catalin

