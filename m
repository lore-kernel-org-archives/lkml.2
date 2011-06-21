Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1FUNTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:19:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56978 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1FUNS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:18:56 -0400
Date: Tue, 21 Jun 2011 14:18:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] ACPI, APEI, GHES, Prevent GHES to be built as
 module
Message-ID: <20110621131842.GA4902@srcf.ucam.org>
References: <1308640587-24502-1-git-send-email-ying.huang@intel.com>
 <1308640587-24502-2-git-send-email-ying.huang@intel.com>
 <20110621072301.GA3263@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621072301.GA3263@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 09:23:01AM +0200, Andi Kleen wrote:
> On Tue, Jun 21, 2011 at 03:16:24PM +0800, Huang Ying wrote:
> > GHES (Generic Hardware Error Source) is used to process hardware error
> > notification in firmware first mode.  But because firmware first mode
> > can be turned on but can not be turned off, it is unreasonable to
> > unload the GHES module with firmware first mode turned on.  To avoid
> > confusion, this patch makes GHES can be enable/disable in
> > configuration time, but not built as module and unload at run time.
> 
> It's better to keep it as a module, but disable unloading.
> You can do that with a __module_get(THIS_MODULE) in the init code
> when FFM is detected.

Anything that's enabled by an _OSC call is expected to be available 
immediately. So the choices are either to ensure that GHES support is 
built in, or to make a second _OSC call when the GHES code is loaded. 
We've seen in the PCIe case that many firmware implementations 
misinterpret multiple attempts to set _OSC with the same UUID, and a 
cursory examination of some implementations of the systemwide one 
suggest that we'd see the same issue there.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
