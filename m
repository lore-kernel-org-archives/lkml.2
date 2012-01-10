Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2AJROR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:14:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36989 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290Ab2AJROQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:14:16 -0500
Date: Tue, 10 Jan 2012 17:14:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/regulator/core.c: Fixes mapping inside
	regulator_mode_to_status() and makes it returning -EINVAL on
	invalid input.
Message-ID: <20120110171412.GA7164@opensource.wolfsonmicro.com>
References: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2> <20120109161456.GC2974@opensource.wolfsonmicro.com> <CAEqHmAte=rvhjGUEdMgNQKfvPxSVTFR5TfWy13VPEhZj0T53KQ@mail.gmail.com> <20120109200734.GB30766@opensource.wolfsonmicro.com> <CAEqHmAtmHjEJUdvkBPhF5PzP4V_xDc5owLJpp0DENsXLs_ynxQ@mail.gmail.com> <20120110001447.GK30766@opensource.wolfsonmicro.com> <CAEqHmAtrUNKTxt3Q8x7=nZNp09ajhyYQn3DmAKd3OUib9hLBUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEqHmAtrUNKTxt3Q8x7=nZNp09ajhyYQn3DmAKd3OUib9hLBUQ@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 05:09:40PM +0000, dd diasemi wrote:
> On Tue, Jan 10, 2012 at 12:14 AM, Mark Brown

> The behaviour is exactly the same in both cases, because
> REGULATOR_STATUS_OFF == 0.

That's not really the intended behaviour...

> From linux/regulator/driver.h:
> enum regulator_status {
>        REGULATOR_STATUS_OFF,

...if it were intended we'd explicitly set the value here to be zero
here.  The intention is to return an "I don't know" value rather than an
error.

> And to set things up, should regulator_get_status() return negative
> error code or REGULATOR_STATUS_OFF (0) on communication failure?

It should return an error when the I/O fails.
