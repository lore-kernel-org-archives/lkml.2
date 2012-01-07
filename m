Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2AGQfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 11:35:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:52819 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2AGQfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 11:35:32 -0500
Message-ID: <1325954125.2442.27.camel@twins>
Subject: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide
 error
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: =?UTF-8?Q?=D0=98=D0=BB=D1=8C=D1=8F_?=
	 =?UTF-8?Q?=D0=A2=D1=83=D0=BC=D0=B0=D0=B9=D0=BA=D0=B8=D0=BD?= 
	<librarian_rus@yahoo.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Date: Sat, 07 Jan 2012 17:35:25 +0100
In-Reply-To: <20120107145645.GA4997@localhost>
References: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
	 <20120107145645.GA4997@localhost>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-07 at 22:56 +0800, Wu Fengguang wrote:
> Subject: 
> Date: Sat Jan 07 22:50:45 CST 2012
> 
> The uninitilized shift may lead to denominator=0 in
> prop_fraction_percpu() and divide error in bdi_dirty_limit().

I'm not seeing how, only proc_change_shift() can change ->index, and it
does that after it writes ->pg[index]->shift.

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  lib/proportions.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux.orig/lib/proportions.c        2012-01-07 22:50:29.000000000 +0800
> +++ linux/lib/proportions.c     2012-01-07 22:50:37.000000000 +0800
> @@ -82,6 +82,7 @@ int prop_descriptor_init(struct prop_des
>  
>         pd->index = 0;
>         pd->pg[0].shift = shift;
> +       pd->pg[1].shift = shift;
>         mutex_init(&pd->mutex);
>         err = percpu_counter_init(&pd->pg[0].events, 0);
>         if (err)
> 
> 
