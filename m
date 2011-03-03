Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab1CCTe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:34:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45023 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1CCTe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:34:26 -0500
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
From: john stultz <johnstul@us.ibm.com>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        tglx@linutronix.de
In-Reply-To: <1299173174-348-3-git-send-email-torbenh@gmx.de>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
	 <1299173174-348-3-git-send-email-torbenh@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 11:34:04 -0800
Message-ID: <1299180844.28285.111.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 18:26 +0100, Torben Hohn wrote:
> First version of a software clock. Not very useful yet,
> as it doesnt generate events, but at least it allows
> for testing the ptp framework without special hardware.

So in the past, I pushed back on Richard for having something similar,
as I'm not psyched about duplicating interfaces. However, your
implementation is CLOCK_MONOTONIC_RAW instead of CLOCK_REALTIME and it
keeps the adjustments internal, I'm not as opposed.

So I think having such test driver is probably reasonable, but please
make it more explicit that it is just a testing driver, and not
something someone should try to use.

> +
> +struct ixp_clock {
> +	struct ptp_clock *ptp_clock;
> +	struct ptp_clock_info caps;
> +	s64 offset_ns;
> +	struct timespec last_timestamp;
> +	s32 freq;
> +};

Probably should rename things from ixp_*


thanks
-john


