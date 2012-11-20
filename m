Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2KTIyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:54:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50509 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2KTIyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:54:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121120084758.GA29199@core.coreip.homeip.net>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
	<27d9eea3815593df228c85958096bc14d7985e7e.1352381962.git.viresh.kumar@linaro.org>
	<CAKohpomky4s0OBYtQhDTZc9OeSo6w_mN9uAqUXpukqR1icvKPA@mail.gmail.com>
	<CAKohpoknJqMzro4gbTH+Rh=T2Bc9ZOVmDbYZsqC4Fjq2Sqsszg@mail.gmail.com>
	<20121120084758.GA29199@core.coreip.homeip.net>
Date: Tue, 20 Nov 2012 14:24:16 +0530
Message-ID: <CAKohpokQDSFHPVGkneAas+6XK09VKUQV-b0H8uqGYfXMJGyFbg@mail.gmail.com>
Subject: Re: [PATCH 2/3] Input: spear-keyboard: Add clk_{un}prepare() support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 14:17, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> No, not really, it just does not work well with devm_* patches that got
> applied: on removal you unprepare clock as the very first operation and
> then devm_* does the rest which is wrong order.

Nice. I don't expect the order would do anything wrong, as we aren't
touching any registers between unpreparing clock and devm_ undo stuff.

> I am looking at adding dem_* for clocks.

You mean, adding devm_clk_prepare, devm_clk_enable, devm_clk_prepare_enable ?
