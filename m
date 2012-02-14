Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab2BNTXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:23:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42888 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2BNTXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:23:06 -0500
Date: Tue, 14 Feb 2012 19:23:00 +0000
From: Matthew Garrett <mjg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, vgoyal@redhat.com,
        seiji.aguchi@hds.com
Subject: Re: [PATCH V3] kmsg_dump: Don't run on non-error paths by default
Message-ID: <20120214192259.GA32339@srcf.ucam.org>
References: <1328888715-21589-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328888715-21589-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 10:45:15AM -0500, Matthew Garrett wrote:
> Since 04c6862c055fb687c90d9652f32c11a063df15cf kmsg_dump() gets run on
> normal paths including poweroff and reboot. This is less than ideal given
> pstore implementations that can only represent single backtraces, since a
> reboot may overwrite a stored oops before it's been picked up by userspace.
> In addition, some pstore backends may have low performance and provide a
> significant delay in reboot as a result.
> 
> This patch adds a printk.always_kmsg_dump kernel parameter (which can also
> be changed from userspace). Without it, the code will only be run on
> failure paths rather than on normal paths. The option can be enabled in
> environments where there's a desire to attempt to audit whether or not
> a reboot was cleanly requested or not.

Anyone? Whose tree should this go through?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
