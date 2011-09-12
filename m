Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1ILXUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:20:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab1ILXUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:20:40 -0400
Subject: Re: [PATCH 06/24] C6X: devicetree
From: Mark Salter <msalter@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Date: Mon, 12 Sep 2011 19:20:35 -0400
In-Reply-To: <20110912201102.GF23345@ponder.secretlab.ca>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-7-git-send-email-msalter@redhat.com>
	 <20110912201102.GF23345@ponder.secretlab.ca>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315869636.11280.26.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 14:11 -0600, Grant Likely wrote:
> On Wed, Aug 31, 2011 at 05:26:41PM -0400, Mark Salter wrote:
> > +		interrupt-controller;
> > +		#interrupt-cells = <1>;
> > +		compatible = "ti,c64x+core-pic";
> 
> The interrupt controller isn't addressable?  Is it integrated into
> the CPU?

Yes, that core controller is controlled through registers accessed
with special-purpose instructions, not MMIO. Other controllers, like
megamodule and some as-yet unimplemented use MMIO.

> 
> > +	};
> > +
> > +	soc@00000000 {
> 
> "soc@2a80000" to match the 'reg' property of this node.

Okay, I think I need a separate node for that reg property. The SoC
address space does actually start at 0. The registers in that reg
property are "SoC-level" registers holding silicon revision, pin
strap status, etc. All of the SoCs have a "device state config"
node which have registers like that. Instead of having them in the
device state block, this SoC has them in a separate area. I just
got lazy and put them the reg property in the soc node, but I think
it really calls for a separate node.

--Mark


