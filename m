Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1ACT7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:59:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38194 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1ACT7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:59:06 -0500
Subject: RE: [PATCHv1 09/12] unicore32 core architecture: timer and time
From: john stultz <johnstul@us.ibm.com>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <00ef01cbab0a$66bfce60$343f6b20$@mprc.pku.edu.cn>
References: <00d601cba465$27154a70$753fdf50$@mprc.pku.edu.cn>
	 <AANLkTinjzzMz4WFRYmjZiM=P6c1wtSxpY2bzOuUe0Vrd@mail.gmail.com>
	 <008f01cbaa62$2001fff0$6005ffd0$@mprc.pku.edu.cn>
	 <00ef01cbab0a$66bfce60$343f6b20$@mprc.pku.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 11:58:53 -0800
Message-ID: <1294084733.2571.54.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 13:52 +0800, Guan Xuetao wrote: 
> > When using clocksource_register_hz(&cksrc_puv3_oscr, CLOCK_TICK_RATE ),
> >  the shift value become 0, and mult value become 0x838a91a7, and the system will be broken
> > after printing "Switching to clocksource oscr".
> > 
> > When using clocksource_register_khz(&cksrc_puv3_oscr, CLOCK_TICK_RATE ),
> > the shift value become 0, and mult value become  0x4359611, and the system will run smoothly,
> > but timer interrupt seems too frequently. Perhaps it is 4 times faster.
> > 
> > For comparison, originally, when shift value is set to 0x12, the mult value become 1175e5e.
> > 
> 
> The error is the implementation of do_div() function.
> When replacing the arch-specific div64.h with asm-generic/div64.h, clocksource_rigister_hz() works.

Oh great! You had me worried I had a bug in the mult/shift calculation.

Great to hear all is working now! If you run into other clock/time
related troubles, please let me know.

thanks
-john



