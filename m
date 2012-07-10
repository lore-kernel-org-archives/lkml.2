Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2GJT1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:27:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33532 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2GJT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:27:48 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.176.107]
In-Reply-To: <485F7F7C-2D0C-4B14-8A46-D42C9F8ED4E4@studiofuga.com>
References: <1341936444-3094-1-git-send-email-fuga@studiofuga.com>
 <CAK=Wgbaf0On3teqOw1myqkS4Dei3Vw2Zn=0xfOv-YiNUjFr0fg@mail.gmail.com> <485F7F7C-2D0C-4B14-8A46-D42C9F8ED4E4@studiofuga.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 10 Jul 2012 22:27:27 +0300
Message-ID: <CAK=WgbZFHzHLxQfoWW4Cz_PpBCzER75KCd=C3WS-7w_LryKuQA@mail.gmail.com>
Subject: Re: [PATCH] rpmsg bus subsys_initcall initialization ordering
To: Federico Fuga <fuga@studiofuga.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Federico,

On Tue, Jul 10, 2012 at 7:43 PM, Federico Fuga <fuga@studiofuga.com> wrote:
> omaprpc is out of the official mainline code, it's inside the official ti/omap branch/project.

Ok, thanks for the explanation. In general, we don't change the
mainline kernel to solve issues with out-of-tree code.

> I guessed that the easier solution had been to change the initialization level, in a similar way it's done by the i2c bus driver for example.
> I don't know if this is the best solution to solve this, maybe the problem could be solved in the omaprpc driver (maybe this could be the right solution).
...
> Really, I don't have enough experience to say if it should be solved this way or not. For what I can see, this seems absolutely logic that busses are initialized before other drivers, so subsys_initcall should be perfectly logic.

I'm not convinced: there is no inherent reason for a bus and its
driver to live in separate initcalls, so this may all just be an
omaprpc issue.

> On the other hand, I didn't find another way to solve this dependency problem. I know there is also a Makefile approach, but the dependent driver (omaprpc) is in the staging driver directory, so I think is not feasible.
> Any other solution?

I'm not familiar with omaprpc, so I can't help much, sorry. The driver
doesn't seem to be in staging btw (or did you mean it lives in staging
in that out-of-tree repository?).

Thanks,
Ohad.
