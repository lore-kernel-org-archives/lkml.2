Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0F1M2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:28:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40251 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0F1M2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:28:22 -0400
Date: Mon, 28 Jun 2010 13:28:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] wait_for_completion_interruptible does not wait !!
Message-ID: <20100628122817.GA27811@sirena.org.uk>
References: <AANLkTikPOcNZk5ISX2WDHSmsPDw_a5_3Ic3owAbO4o0y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikPOcNZk5ISX2WDHSmsPDw_a5_3Ic3owAbO4o0y@mail.gmail.com>
X-Cookie: Life is the urge to ecstasy.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 11:52:10PM -0700, Suresh Rajashekara wrote:
> I have an application which calls the ioctl of the codec driver to
> know the status of the headset.

> The ioctl waits on a completion variable (using
> wait_for_completion_interruptible).

There is standard support for headset status reporting via the input
layer in mainline, I would recommend implementing your headset detection
in terms of this.

> The problem starts when we suspend the OMAP. The moment we suspend,
> the wait_for_completion_interruptible is interrupted and the ioctl
> returns. Application ends up thinking that the headset was either
> removed/inserted. Our system does an aggressive sleep (wakes up every
> 500 ms and sleeps again) and hence the application gets the event of
> headset every 500 ms.

The input layer does not have this problem.
