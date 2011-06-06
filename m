Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1FFFuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 01:50:16 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:3089 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1FFFuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 01:50:13 -0400
Subject: Re: [PATCH] ATMEL, AVR32: inline nand partition table access
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
References: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>
	 <1306935129.1097.3.camel@hcegtvedt.norway.atmel.com>
	 <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 06 Jun 2011 07:49:31 +0200
Message-ID: <1307339371.9413.5.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2011 05:49:35.0514 (UTC) FILETIME=[84072FA0:01CC240D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 18:54 +0400, Dmitry Eremin-Solenikov wrote:
> On 6/1/11, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> > On Sun, 2011-05-29 at 17:49 +0400, Dmitry Eremin-Solenikov wrote:
> >> Currently atmel_nand driver used by AT91 and AVR32 calls a special
> >> callback
> >> which return nand partition table and number of partitions. However in all
> >> boards this callback returns just static data. So drop this callback and
> >> make atmel_nand use partition table provided statically via platform_data.
> >>
> >> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> >
> > Thanks for this update, always nice seeing code being optimized. I
> > really can't recall why it was made like this in the first place...
> >
> > For the AVR32 related parts:
> >
> > Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> >
> > <snipp diff>
> >
> > Will this go through the linux-mtd tree (since it spans two archs) or
> > should it go through an arch tree?
> 
> On one hand, I'd prefer for this to go through the linux-mtd, if noone objects,
> as I'd also like to submit several (a pile) patches cleaning up mtd
> partitioning, which would depend on this.

I'm fine by sending the changes for AVR32 through linux-mtd, they are
minor and so far doesn't touch anything else that is changed.

> OTOH, I think there will be a cleanup of AT91 platform, which would bring
> lot's of conflicts with this patch, if it goes through linux-mtd.

AT91 will probably be worse, yes, should be doable by git to solve the
conflicts on its own. I'll leave it to Nicolas to give his verdict.

-- 
Hans-Christian Egtvedt

