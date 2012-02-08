Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2BHQh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:37:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57965 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2BHQh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:37:26 -0500
Date: Wed, 8 Feb 2012 16:37:20 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, seiji.aguchi@hds.com, dzickus@redhat.com
Subject: Re: [PATCH] kmsg_dump: Don't run on non-error paths by default
Message-ID: <20120208163720.GB3322@srcf.ucam.org>
References: <1328717646-17121-1-git-send-email-mjg@redhat.com>
 <20120208163007.GA19323@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208163007.GA19323@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 11:30:07AM -0500, Vivek Goyal wrote:

> > +	if (reason > KMSG_DUMP_PANIC && !always_kmsg_dump)
> > +		return;
> 
> Did you mean reason > KMSG_DUMP_OOPS to enable oops logging by default?

Bah. Yes, I think my test system was set to panic on oops so I didn't 
catch that.

> Given the fact that not everybody likes kmsg_dump() and it is not known
> how stable it with various backends, will it make sense to keep it disabled
> by default and provide a knob to enable it (instead of always_kmsg_dump).

I think logging panics and oopses by default is a useful feature. It may 
be desirable to have a mechanism to disable it if some other way of 
handling that (serial console, kdump) is available.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
