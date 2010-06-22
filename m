Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0FVImR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:42:17 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:41179 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0FVImP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:42:15 -0400
Date: Tue, 22 Jun 2010 10:42:10 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.36] gspca for_2.6.36
Message-ID: <20100622104210.5eee4849@tele>
In-Reply-To: <4C201089.20008@redhat.com>
References: <20100605133328.4c1089f2@tele>
	<4C201089.20008@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 22:23:21 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> > Jean-François Moine (15):
> >       gspca - JPEG subdrivers: Don't allocate the JPEG header.
> >       gspca - stk014: Change the min and default values of the JPEG
> > quality. gspca - zc3xx: Change the max and default JPEG qualities.
> >       gspca - zc3xx: Don't change the registers 7 and 8 for sensor
> > pas202b. gspca - zc3xx: Add back the brightness control.  
> 
> >       gspca: Remove/move useless inclusions of slab.h.  
> 
> This patch doesn't seem right. The addition of slab.h were done in
> order to allow the removal of the header from some core files. I'm
> not sure if all the upstream changes got applied to 2.6.35, but it
> seems prudent to wait for a while before just removing the headers,
> especially since the slab.h dependency may be different on non-Intel
> architectures.
> 
> I'm applying the remaining patches. If you think that this patch is
> correct, please re-send it to both LMML and LKML, c/c the authors of
> the slab.h removal, in order to get their acks, or, otherwise, please
> re-submit it for 2.6.37 window.

Hi Mauro,

The slab.h dependency was changed in the kernel 2.6.34 and its
inclusion in some gspca source files was needed in case of the usage of
kmalloc/kfree only.

After removing the JPEG header allocation, most gspca subdrivers do not
use alloc/free anymore, so, there is no need to include slab.h anymore.

On the other side, this patch is easily checked because, if wrong, it
raises compilation errors on any architecture.

Then, both patches (removal of JPEG alloc/free and slab.h inclusion)
should go to 2.6.36.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
