Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0KJGXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:23:14 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54667 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab0KJGXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:23:13 -0500
Date: Tue, 9 Nov 2010 23:23:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Brownell <david-b@pacbell.net>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Cyril Chemparathy <cyril@ti.com>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
Message-ID: <20101110062310.GB7431@angua.secretlab.ca>
References: <20101110044530.GB4110@angua.secretlab.ca>
 <79124.87409.qm@web180307.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79124.87409.qm@web180307.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:16:22PM -0800, David Brownell wrote:
> 
> > I thought the point of this device was that a single [SSP] device
> > hosted a
> > pair of multi-function serial interfaces, with each
> > implementing a
> > separate function.
> 
> function chosen based on what the board needs.
> Codec interface, SPI, GPIO, etc.
> 
>   If so, then it makes sense for the
> > base driver to
> > register child devices of the appropriate kinds.
> 
> I'd normally say board setup registers them; a
> "core"driver can't know what children would be needed.
> 
> But the point I was making was about code factoring
> not driver setup.  When  the functions don't have
> much commonality, they might as well just write to
> the relevant registers instead of expecting to have
> a non-register programming interface (of dubious
> generality of a "core" driver, but much complexity).
> 
> Easier just to have children use registers directly,
> in several similar cases.  Less overhead, too.

I guess it depends on how much overlap/interlock there is between the
multiple channels.  If there is shared context, then that is a
stronger argument for a shared api.  Cyril, what say you?

g.

