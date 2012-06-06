Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2FFT6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:58:43 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:55410 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab2FFT6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:58:42 -0400
Date: Wed, 6 Jun 2012 21:58:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, baryluk@smp.if.uj.edu.pl,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        devel@open-fcoe.org, Mark Rustad <mark.d.rustad@intel.com>,
        yi.zou@intel.com
Subject: Re: [PATCH] libfcoe: Fix section mismatch
Message-ID: <20120606195840.GA31186@merkur.ravnborg.org>
References: <138EA028228D124A900F5E6746F3C216286EAA65@ORSMSX102.amr.corp.intel.com> <20120606185948.26178.86781.stgit@fritz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606185948.26178.86781.stgit@fritz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:59:48AM -0700, Robert Love wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Recent changes to add fcoe_sysfs caused libfcoe_init to call fcoe_transport_exit
> in a module initialization routine. The change resulted in the below error. This
> patch removes the __exit keyword from the fcoe_transport_exit definition such
> that it may be called from an __init routine.
> 
> WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x21): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transp
> exit()
> The function __init init_module() references
> a function __exit fcoe_transport_exit().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __exit annotation of
> fcoe_transport_exit() so it may be used outside an exit section.
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Robert Love <robert.w.love@intel.com>

Looks good.

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
