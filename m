Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1AKJGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:06:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42675 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AKJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:06:29 -0500
Date: Tue, 11 Jan 2011 09:06:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mm: Poison freed init memory
Message-ID: <20110111090615.GH12552@n2100.arm.linux.org.uk>
References: <1294256845-29517-1-git-send-email-sboyd@codeaurora.org> <20110105202645.GL8638@n2100.arm.linux.org.uk> <4D255263.7040106@codeaurora.org> <20110106090741.GQ8638@n2100.arm.linux.org.uk> <4D2BE3E1.5060706@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2BE3E1.5060706@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 09:00:17PM -0800, Stephen Boyd wrote:
> Ok it seems that 0xcc was chosen by Pavel since it's a breakpoint
> instruction (sorry for not noticing that earlier [1]).

It may be on x86, but on ARM:

   0:   cccccccc        stclgt  12, cr12, [ip], {204}

That's a co-processor #12 instruction which will only be executed of
the processor condition codes satisfy 'gt'.

> There was some discussion about handling initdata with Pavel's patch
> but it seems that nothing came of it?

I'm not sure who this Pavel is who you keep referring to - the message
you link to is a discussion between William Irvin and hpa.

> How about we use 0xe7fddef0? This seems to satisfy at least your first
> point for both ARM and Thumb mode (Thumb will branch to the 0xdef0
> instruction).

Yup.
