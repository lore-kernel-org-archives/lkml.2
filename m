Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1BRBIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:08:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38981 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1BRBIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:08:35 -0500
Date: Fri, 18 Feb 2011 01:08:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Greg KH <greg@kroah.com>, Charles Manning <manningc2@actrix.gen.nz>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110218010811.GA19883@sirena.org.uk>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171531.03924.manningc2@actrix.gen.nz> <4D5C8D62.4060809@bluewatersys.com> <201102171649.57457.manningc2@actrix.gen.nz> <20110217234154.GA1474@kroah.com> <20110218000150.GA27668@opensource.wolfsonmicro.com> <20110218003353.GA25386@kroah.com> <20110218004354.GB27668@opensource.wolfsonmicro.com> <4D5DC368.2080003@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5DC368.2080003@bluewatersys.com>
X-Cookie: You've been Berkeley'ed!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 01:55:04PM +1300, Ryan Mallon wrote:
> On 02/18/2011 01:43 PM, Mark Brown wrote:

> > That'd be the tracepoints I was mentioning, then...

> Are you suggesting that the yaffs_trace function should be replaced with
> tracepoints?

Not really.  I'm suggesting that the useful callers might well be best
replaced by tracepoints.

> yaffs_trace is basically just a wrapper around printk, which I suggested
> should be replaced with pr_debug so that it can be compiled out
> completely. Other drivers and filesystems have similar custom debugging
> functions.

> I haven't used tracepoints, but it seems like they are better suited to
> tracing specific events than as a general printk style debugging
> replacement?

Yup, but often things that are being traced by printk() debugging can
usefully be converted to tracepoints.  I'm not sure exactly what people
use this logging for but some of the YAFFS_TRACE_MTD type trace which
logs interactions with the hardware seems like a good candidate for
example.
