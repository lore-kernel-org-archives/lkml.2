Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab1GDRxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:53:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54962 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab1GDRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:53:39 -0400
Subject: Re: [PATCH] regulator: Do bulk enables of regulators in parallel
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1306195960-5897-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1306195960-5897-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 18:53:34 +0100
Message-ID: <1309802014.3272.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 08:12 +0800, Mark Brown wrote:
> In order to reduce the impact of ramp times rather than enabling the
> regulators for a device in series use async tasks to run the actual
> enables. This means that the delays which the enables implement can all
> run in parallel, though it does mean that the order in which the
> supplies come on may be unstable.
> 
> For super bonus fun points if any of the regulators are shared between
> multiple supplies on the same device (as is rather likely) then this
> will test our locking.  Note that in this case we only delay once for
> each physical regulator so the threads shouldn't block each other while
> delaying.
> 
> It'd be even nicer if we could coalesce writes to a shared enable registers
> in PMICs but that's definitely future work, and it may also be useful
> and is certainly more achievable to optimise out the parallelism if none
> of the regulators implement ramp delays.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Targetted at 2.6.41 obviously.
> 

Applied.

Thanks

Liam

