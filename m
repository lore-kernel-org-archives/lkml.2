Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2KPTdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:33:40 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35189 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2KPTdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:33:39 -0500
MIME-Version: 1.0
X-Originating-IP: [85.250.20.247]
In-Reply-To: <1353070447.15558.1681.camel@cliu38-desktop-build>
References: <1353070447.15558.1681.camel@cliu38-desktop-build>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 16 Nov 2012 21:33:18 +0200
Message-ID: <CAK=WgbYiKFpSeyKZU3OWvbq4VDKRMFQvxwPbyxsBbEYJGQU1sA@mail.gmail.com>
Subject: Re: [PATCH] mmc,sdio: Fix the panic due to devname NULL when calling pm_runtime_set_active()
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

On Fri, Nov 16, 2012 at 2:54 PM, Chuansheng Liu
<chuansheng.liu@intel.com> wrote:
> So when calling pm_runtime_set_active(), it will hit the strlen(devname==0)
> which trigger the panic.

Can you please point to the exact line of code that triggers this panic ?

> Here before calling pm_runtime_set_active(), set the dev name, although
> it is duplicated with mmc_add_card(), but it do not break the original
> design(commit 81968561b).

Normally we'd like to avoid such a solution, so let's first make sure
we understand the problem.

Have you tried thinking how come this shows up only now - has any of
the relevant code been changed lately ? Are you using a vanilla Linux
tree ?

Thanks,
Ohad.
