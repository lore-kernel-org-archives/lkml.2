Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1BGL66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:58:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48196 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1BGL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:58:57 -0500
Date: Mon, 7 Feb 2011 11:58:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/09] ARM: s3c2440: gta02: Call
	regulator_has_full_constraints
Message-ID: <20110207115820.GB1196@sirena.org.uk>
References: <1297043521-21903-1-git-send-email-lars@metafoo.de> <1297043521-21903-7-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297043521-21903-7-git-send-email-lars@metafoo.de>
X-Cookie: Torque is cheap.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 02:51:59AM +0100, Lars-Peter Clausen wrote:
> At the end of gta02_pmu_attach_child_devices all drivers should have taken
> control of their regulators and we can tell the regulator core to disable all
> regulators which are currently not in use.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

You're misunderstanding this API.  It can be called at any time and will
only actually do anything at the end of init.  You should just call it
from your machine init.
