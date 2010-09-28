Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0I1TNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:13:13 -0400
Received: from haybaler.sackheads.org ([140.186.190.103]:63949 "EHLO
	haybaler.sackheads.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab0I1TNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:13:11 -0400
DomainKey-Signature: a=rsa-sha1; s=haybaler; d=sackheads.org; c=nofws; q=dns;
	h=dkim-signature:received:received:date:from:to:cc:subject:
	message-id:references:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=e5BRS7bOimXWcMXUGAF6rcK5OE9ykLM044BnmPIee3zv4/NwGvP7/iAgg5HJpmuoX
	PBOqCTOywzFPhRyS7jOK0lZycakQ3JGc0eZSIzMaFMlFhPXUN44dlWj/4N36DvbH1I/
	s9YX7585k2euUDYZD9Jd/W3stGWgetR2Stt51wA=
Date: Tue, 28 Sep 2010 15:13:08 -0400
From: Jimmie Mayfield <mayfield@sackheads.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trying to reset a PCIe device and scratching my head...
Message-ID: <20100928191307.GA54440@sackheads.org>
References: <20100928020548.GA90230@sackheads.org> <4CA1990E.9080206@ladisch.de> <20100928090655.158d1675@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928090655.158d1675@jbarnes-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:06:55AM -0700, Jesse Barnes wrote:
> Right, if your system supports this, it may be the easiest way to go.

I was under the impression that PCIe requires support for at least
fundamental reset and maybe hot reset (secondary bus reset) though I'd
have to go back to the spec to verify the latter.  Are you saying that
not all PCIe chipsets support this?  Sorry if this seems like a dumb 
question...I'm by no means a PCIe guru.

> But devices often have proprietary ways of resetting themselves too;
> maybe you could change your device to reset if a specific bit in config
> or MMIO space was flipped.  You'd likely need some sort of delay before
> accessing the device again, but it should be bounded and fairly fixed,
> so probably not a big deal for the driver to handle.

Indeed, the device does support a proprietary reset via MMIO but 
that reset only affects those components that lie behind the card's PCIe 
interface.  So it's nearly a full device reset but not quite.  The FPGA 
containing the PCIe interface does not get reloaded.  Unfortunately, that 
behavior is likely set in stone.  

Jimmie

