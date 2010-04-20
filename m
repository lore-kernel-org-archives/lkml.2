Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0DTR2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:28:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47745 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754834Ab0DTR2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:28:02 -0400
Date: Tue, 20 Apr 2010 18:32:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Wright <wrightd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Should calculation of vm.overcommit_ratio be changed?
Message-ID: <20100420183252.0c61208f@lxorguk.ukuu.org.uk>
In-Reply-To: <y2kf16bc8301004200640r9485da73p920a2f5c3e2d949e@mail.gmail.com>
References: <y2kf16bc8301004200640r9485da73p920a2f5c3e2d949e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> might have 4GB RAM and 1GB swap. I don't think you would expect
> Desktop users to understand or tweak overcommit_ratio, but I also
> don't think having the distro simply change the default from 50 (to
> 100 or something else) would cover all the cases well.

Sounds like the distribution should be tuning the value according to the
> 
> Would it make more sense to have the overcommit formula be calculated as:
> 
> max commit = min(swap, ram) * overcommit_ratio + max(swap, ram) ?
> 
> When swap>=ram, the formula works exactly the same as it does now, but
> when ram>>swap, you are guaranteed to always be able to your full RAM
> (even when swap=0).

Which is wromg - some of your RAM ends up eaten by the kernel, by
pagetables and buffers etc. 50% is probably very conservative but the
point of VM overcommit is exactly that - and you end up deploying swap
as a precaution against disaster rather than because you need it.

