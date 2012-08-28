Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2H1PyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:54:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55316 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2H1Pxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <503CB7A8.4050600@nvidia.com>
References: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
 <5034AA28.5050306@nvidia.com> <20120823145308.GA28328@sirena.org.uk>
 <50364179.6070304@nvidia.com> <5037BF45.1070205@nvidia.com>
 <20120824233835.GA29178@ubuntu> <503CB7A8.4050600@nvidia.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 28 Aug 2012 17:52:49 +0200
X-Google-Sender-Auth: hDiIpzUd2j7end8X5StGcSEE8P4
Message-ID: <CAH+eYFBN01kRHXdHhbzJgLx+JBbz0T4UmbKxJeZ=od3B+rvRqw@mail.gmail.com>
Subject: Re: [PATCH] regulator: disable supply regulator if it is enabled for boot-on
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/28 Laxman Dewangan <ldewangan@nvidia.com>:
> I tried to reproduce the lockup issue with the following change but not
> seeing any lockup issue.

Did you enable CONFIG_PROVE_LOCKING?

> Also reviewing the change, I am not seeing any call trace where the
> recursive locking happening.

There's probably no actual recursive locking, but the lockdep warning
itself is a problem which must be eliminated.  You could perhaps do this
by doing the regulator_disable(rdev->supply); after you mutex unlock the
rdev->mutex.
