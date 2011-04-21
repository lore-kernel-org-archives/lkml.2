Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1DUUde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:33:34 -0400
Received: from kroah.org ([198.145.64.141]:59481 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1DUUdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:33:32 -0400
Date: Thu, 21 Apr 2011 13:34:37 -0700
From: Greg KH <greg@kroah.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: Export pci device msi table via sysfs
Message-ID: <20110421203437.GB15929@kroah.com>
References: <1303412267-1948-1-git-send-email-nhorman@tuxdriver.com>
 <20110421191041.GE31296@parisc-linux.org>
 <20110421200039.GC18449@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421200039.GC18449@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 04:00:39PM -0400, Neil Horman wrote:
> On Thu, Apr 21, 2011 at 01:10:41PM -0600, Matthew Wilcox wrote:
> > On Thu, Apr 21, 2011 at 02:57:47PM -0400, Neil Horman wrote:
> > > b) msi_table - populated only if msi(x) is enabled, it lists the irqs allocated
> > > to the pci device
> > 
> > You're not the first one to try this ... the problem is, you can easily
> > overflow a single 4k page.  A device can have up to 2k MSI-X entries,
> > and we might take up to 5 bytes for each one, so we'd need a 10k buffer.
> > 
> Yeah, I was a bit worried about that - but I didn't think any sane device would
> allocate en entire 2048 irqs (not that thats an excuse).  I had considered doing
> an export format like local_cpulist where consecutive irq allocations are listed
> as first-last, which would save space and keep us inside a page.  Thoughts?

Nope, again, sysfs is "one value per file" please.  So don't do it this
way.

If you look in the archives, I've posted how this could be done, but it
gets really messy quickly, as people have found out.  You should look
there first at those attempts before you reinvent them here (as you are
doing...)

thanks,

greg k-h
