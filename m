Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2I1Csd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:48:33 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37433 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2I1Csc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:48:32 -0400
Date: Thu, 27 Sep 2012 19:45:44 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 51/57] power: ab8500: Re-alignment with internal
 developement.
Message-ID: <20120928024544.GA12873@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-52-git-send-email-mathieu.poirier@linaro.org>
 <20120928023510.GJ5040@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120928023510.GJ5040@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:35:10PM -0700, Anton Vorontsov wrote:
[...]
> abx500_chargalg_check_safety_timer()
> {
> 	if (di->batt_data.percent < 100) {
> 		dev_dbg(di->dev, "stopping safety timer\n");
> 		abx500_chargalg_stop_safety_timer(di);
> 		return;
> 	}
> 
> 	dev_dbg(di->dev, "starting safety timer\n");
> 	abx500_chargalg_start_safety_timer(di);
> }
> 
> The thing is, restarting an already pending timer is no-op, unless you
> program the timer before the previously programmed value.

Oh, actually, no. It's no-op if old expires == new expires. :-/

So, yes, you need to check for pending before (re)starting. So, it'll
become

	if (pending)
		return;
	abx500_chargalg_start_safety_timer(di);

(Or better, start_safety_timer() should do that, and it seems that it
already does.)

Thanks,
Anton.
