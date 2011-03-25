Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab1CYHOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:14:34 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41322 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032Ab1CYHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:14:33 -0400
X-Originating-IP: 217.70.178.44
X-Originating-IP: 134.134.139.72
Message-ID: <4D8C40D0.80109@pbjtriplett.org>
Date: Fri, 25 Mar 2011 00:14:24 -0700
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86/microcode: intel: correctly handle negative revisions
References: <4D65EE74.1050709@pbjtriplett.org> <20110312023001.GB27550@khazad-dum.debian.net> <4D87E2CD.6020306@pbjtriplett.org> <20110324001451.GA7950@khazad-dum.debian.net> <20110325020954.GC4535@khazad-dum.debian.net>
In-Reply-To: <20110325020954.GC4535@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/24/2011 7:09 PM, Henrique de Moraes Holschuh wrote:
> As per the Intel SDM vol 3A, microcode revisions are signed 32-bit
> numbers.  The code was handling them as unsigned int in some places and as
> an int in other places.
> 
> As per the clarification posted by Burt Triplett from the Intel BITS
> project, negative microcode revisions are used internally at Intel and
> should always get loaded.  Also, they should not be overriden unless we
> can somehow differentiate "automated" loading from "forced" loading (which
> we cannot at this time).  Burt says the SDM will be updated with this
> information eventually.
> 
> The code should:
> 
> 1. Ignore attempts to load a zero-revision microcode (that value is
> reserved for the CPU to signal that it is running with the factory
> microcode, and must not be present in a normal microcode update);
> 
> 2. Always load negative revision microcodes, to help Intel's engineers;
> 
> 3. Avoid upgrading from a BIOS-loaded negative revision microcode to
> a normal microcode, to not get in the way of Intel's engineers.
> 
> 4. Upgrade from revision 0 (no updates loaded in CPU) to any revision.
> 
> It was already doing some of that, but I don't feel like trying to track
> down exactly how the old code with its mix of signed/unsigned handling of
> revisions would behave in each of the above cases.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> LKML-Reference: <4D87E2CD.6020306@pbjtriplett.org>
> Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Burt Triplett <burt@pbjtriplett.org>

Reviewed-by: Burt Triplett <burt@pbjtriplett.org>

Thanks,
Burt Triplett
