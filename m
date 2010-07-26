Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0GZVO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:14:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47282 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0GZVOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:14:55 -0400
Date: Mon, 26 Jul 2010 22:14:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        David Quan <David.Quan@atheros.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
Message-ID: <20100726211424.GA5197@srcf.ucam.org>
References: <1276859156.19554.2.camel@maxim-laptop> <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> <1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> <20100619123841.GA31838@hash.localnet> <1276952554.3332.3.camel@maxim-laptop> <1276961564.5173.12.camel@maxim-laptop> <20100726201322.GI14855@tux> <1280177362.3721.7.camel@maxim-laptop> <20100726210651.GJ14855@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726210651.GJ14855@tux>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 02:06:51PM -0700, Luis R. Rodriguez wrote:

> No, ASPM must be enabled by the Systems Integrator through the BIOS, there are
> other settings that have to be taken care of like modifying some PCI entrance and
> exit latency timers, the number of FTS packets we send to exit L0s, amongst
> other things. If a user selectively enables L1 but the BIOS had it disabled on
> the device it may not work correctly.

That's really the job of the driver. If the ASPM policy is set to 
powersave, the fadt doesn't indicate that ASPM should be disabled and 
the bus's _OSC method grants full control then the kernel will enable 
whatever combination of L states meet the latency constraints. If the 
hardware has additional constraints then the hardware-specific driver 
needs to handle them.

We don't rely on the BIOS to set up ASPM states. Nor does Windows.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
