Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2KTJgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:36:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46214 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2KTJgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:36:06 -0500
Date: Tue, 20 Nov 2012 09:32:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121120093242.GK3290@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com> <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 01:22:17AM -0800, Dmitry Torokhov wrote:
> We'll need to invoke clk_unprepare() via a pointer in our devm_*
> conversion so let's uninline the pair.

NAK.  This breaks non-common clock using implementations.

Why do you need to call this function via a pointer?  That sounds absurd.
