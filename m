Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2FIP75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 11:59:57 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:62537 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab2FIP7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 11:59:55 -0400
X-Greylist: delayed 703 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jun 2012 11:59:55 EDT
Message-ID: <4FD37014.90109@newsguy.com>
Date: Sat, 09 Jun 2012 08:47:32 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120606 Thunderbird/10.0.4
MIME-Version: 1.0
To: Shmulik Ladkani <shmulik@jungo.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ivan Djelic <ivan.djelic@parrot.com>
Subject: Re: [PATCH] mtd: nand: Properly initialize 'mtd->bitflip_threshold'
 prior 'scan_bbt()' is invoked
References: <20120608182906.57b4844a@halley>
In-Reply-To: <20120608182906.57b4844a@halley>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 08:29 AM, Shmulik Ladkani wrote:
> As of edbc454 [mtd: driver _read() returns max_bitflips; mtd_read()
> returns -EUCLEAN], 'mtd->bitflip_threshold' must be set for mtd devices
> having ECC, prior any 'mtd_read()' call.
> Otherwise, 'mtd_read()' will falsely return -EUCLEAN.
> 
> Normally, 'mtd->bitflip_threshold' is initialized when the MTD is added.
> 
> However, this is too late for NAND MTDs, as 'scan_bbt()' is invoked
> prior the existing initialization of 'mtd->bitflip_threshold'.
> 
> This is a problem since 'scan_bbt()' calls 'mtd_read()', in the case
> of a flash-based bad block table.
> It resulted in a falsely reported bitflips indication during BBT read,
> which lead to constant scrubbing of the flash BBT blocks.
> 
> Initialize 'mtd->bitflip_threshold' to its default value (if not already
> set by the driver), prior invocation of 'scan_bbt()'.
> 

Reviewed-by: Mike Dunn <mikedunn@newsguy.com>
(FWIW).

Thanks again Shmulik!

I do think that the patch to the bad block management code that I sent yesterday
should be merged as well.  That would also fix the problem, but it is really a
separate issue.  Currently ecc errors are ignored during the BBT creation for
some configurations but not for others (like that of the mxc_nand controller).
It looks like an oversight that they are not ignored, and it makes sense to
ignore them, since there's not much you can do about them at that time, and the
functions higher up the call stack don't try to.

Thanks,
Mike
