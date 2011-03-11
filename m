Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1CKP3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:29:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33945 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab1CKP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:29:40 -0500
Date: Fri, 11 Mar 2011 15:29:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: andy.green@linaro.org, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311152938.GB29920@sirena.org.uk>
References: <4D79F068.2080009@linaro.org> <201103111331.13932.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103111331.13932.arnd@arndb.de>
X-Cookie: Nihilism should commence with oneself.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 01:31:13PM +0100, Arnd Bergmann wrote:

> I understand the problem, but IMHO there really needs to be a better
> solution for this. As far as I understand, the underlying problem is
> that USB ethernet devices with a proper MAC address get a different
> device name from devices with a generated random MAC address, and
> the people that designed this board were trying to save a few cents
> by not allocating a MAC address for the ethernet device [1], right?

> I believe we should fix this particular problem locally, instead of
> coming up with generic infrastructure for broken hardware.

It's arguable if this stuff is broken at all, from a hardware design
point of view it's perfectly reasonable and if you're shipping volumes
in the millions very small savings add up to interesting numbers easily.

> One relatively easy solution would be to allow passing a MAC address
> to this particular device driver as a module parameter, and generating
> a fixed MAC address in the regular vendor space when installing the
> boot loader. That would also solve the problem that a DHCP server
> currently assigns a new IP address to a panda board at every boot.

There's other uses for this stuff, it seems to be quite common for
various radio related things to end up hanging off USB too.
