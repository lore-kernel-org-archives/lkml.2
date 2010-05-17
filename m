Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0EQR6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:58:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50848 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0EQR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:58:45 -0400
Date: Mon, 17 May 2010 18:58:20 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100517175820.GA29773@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org> <87hbm6cz90.fsf@deeprootsystems.com> <1274115885.4418.59.camel@mulgrave.site> <20100517174647.GA11512@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517174647.GA11512@gandalf>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 08:47:31PM +0300, Felipe Balbi wrote:

> IMO the real fix would be on that particular poll(), changing the
> timeout e.g. based on cpufreq notifications or even relying completely
> on IRQs with poll(pdfs, ARRAY_SIZE(pfds), -1); Of course, this is only a
> crude example trying to show that the real issue lies on the application
> rather than on kernel.

We know that this problem is mostly uninteresting if your userland is 
well written. The sad truth is that it's impossible to trust that your 
userland is well written, and broadly impossible to communicate to users 
that the reason that their battery life is miserable is because of the 
applications and not because of the platform. If you don't believe that 
that's a worthwhile use case to deal with then suspend blockers buy you 
pretty much nothing. But if you do, then nobody's yet demonstrated 
another workable way for this to be handled.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
