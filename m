Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1HaQbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:31:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54026 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756322Ab1HaQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:31:32 -0400
Date: Wed, 31 Aug 2011 17:31:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>, Ben Dooks <ben-linux@fluff.org>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
Message-ID: <20110831163129.GY2061@opensource.wolfsonmicro.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
 <CAMbhsRRRa_JV8_LHEvsM2h3e8Hbf1GAcpXz8gdU3wCc8Jgz5gw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04B3279D4F@HQMAIL01.nvidia.com>
 <201108311828.40783.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108311828.40783.arnd@arndb.de>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 06:28:40PM +0200, Arnd Bergmann wrote:

> Sorry, I normally like to give my opinion on everything, but I really don't
> have a clue what this one is about. I don't understand i2c or power management ;-)

The issue is that due to our sequencing suspend and resume using the
control heirachy rather than dependencies we attempt to suspend the I2C
controller prior to some devices that need it.  As we don't have a good
solution for this at the minute where it's an issue we've been avoiding
it by using the _noirq() suspend and resume functions for the controller
to reorder their suspend with respect to the rest of the system.  It's
not great but practically speaking it works.
