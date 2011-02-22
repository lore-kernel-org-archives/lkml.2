Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1BVCe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:34:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38432 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1BVCez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:34:55 -0500
Date: Tue, 22 Feb 2011 02:34:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rtc-linux@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222023452.GB18299@sirena.org.uk>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org> <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
X-Cookie: Preserve the old, but know the new.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:55:32PM -0800, John Stultz wrote:
> With the generic rtc code managing the now virtualized alarm timer,
> no one actually calls rtc_clas_ops->read_alarm().

> We do check that it exists in rtc_read_alarm(), but that is only
> to verify that the hardware supports irqs. The same test can
> be done by checking set_alarm instead.

> This patch changes the the read_alarm check to set_alarm, and then
> removes the read_alarm method and its implementations in the rt
> drivers.

Can you go into more detail on the rationale behind this virtualised
functionality and how it works?  I'd really expect the RTC alarm to be
preserved over system reboots (on some systems it can be used to
initiate a boot) and that would mean that we need to go to the hardware
for at least the initial configuration.
