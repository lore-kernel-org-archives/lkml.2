Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab2AJAOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:14:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45364 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933455Ab2AJAOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:14:50 -0500
Date: Tue, 10 Jan 2012 00:14:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/regulator/core.c: Fixes mapping inside
	regulator_mode_to_status() and makes it returning -EINVAL on
	invalid input.
Message-ID: <20120110001447.GK30766@opensource.wolfsonmicro.com>
References: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2> <20120109161456.GC2974@opensource.wolfsonmicro.com> <CAEqHmAte=rvhjGUEdMgNQKfvPxSVTFR5TfWy13VPEhZj0T53KQ@mail.gmail.com> <20120109200734.GB30766@opensource.wolfsonmicro.com> <CAEqHmAtmHjEJUdvkBPhF5PzP4V_xDc5owLJpp0DENsXLs_ynxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEqHmAtmHjEJUdvkBPhF5PzP4V_xDc5owLJpp0DENsXLs_ynxQ@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 12:11:33AM +0000, dd diasemi wrote:

> Making regulator_mode_to_status() returning an error allows to
> simplify its usage:
> 	ret = regulator_mode_to_status(regulator_get_mode(rdev));
> 	if (ret < 0)
> 		ret = -EIO;

That code would definitely be less than ideal - if we got an error back
from the attempt to read the mode we ought to be returning that error
not squashing it down to a single value.
