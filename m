Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1KHJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:26:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:39175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1KHJ0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:26:22 -0500
Subject: Re: [patch 1/3] sched: use jump labels to reduce overhead when
 bandwidth control is inactive
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Date: Tue, 08 Nov 2011 10:26:18 +0100
In-Reply-To: <20111108042736.560831357@google.com>
References: <20111108042632.977080206@google.com>
	 <20111108042736.560831357@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320744378.2244.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 20:26 -0800, Paul Turner wrote:
> +static void account_cfs_bandwidth_used(int enabled, int was_enabled)
> +{
> +       /* only need to count groups transitioning between enabled/!enabled */
> +       if (enabled && !was_enabled)
> +               jump_label_inc(&__cfs_bandwidth_used);
> +       else if (!enabled && was_enabled)
> +               jump_label_dec(&__cfs_bandwidth_used);
> +} 

Can't you use jump_label_enabled(&__cfs_bandwidth_used) to was_enabled ?
