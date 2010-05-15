Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0EOTyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 15:54:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52883 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0EOTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 15:54:39 -0400
Date: Sat, 15 May 2010 20:54:01 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100515195401.GA29677@srcf.ucam.org>
References: <20100513192522.GA19256@srcf.ucam.org> <20100513194205.GC3428@atomide.com> <20100513195349.GB19722@srcf.ucam.org> <20100513200003.GE3428@atomide.com> <20100513200814.GA20254@srcf.ucam.org> <20100513202320.GF3428@atomide.com> <20100513203412.GA21244@srcf.ucam.org> <20100513211006.GG3428@atomide.com> <20100513212108.GA22103@srcf.ucam.org> <20100513213455.GK3428@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513213455.GK3428@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 02:34:55PM -0700, Tony Lindgren wrote:
> * Matthew Garrett <mjg@redhat.com> [100513 14:16]:
> > What race-free mechanism do you use to ensure that? It's very easy to 
> > handwave these problems away. It's very difficult to actually write an 
> > implementation that works.
> 
> Can you describe where do you see the race now?

1) Trusted app decides to suspend
2) Network packet that would otherwise wake the system is received
3) Trusted app sends SIGSTOP to untrusted userspace
4) Network packet sits waiting for stopped userspace to process it

Unless the trusted userspace gets woken up on every event that would 
potentially cause a wakeup, you're racy. And the alternative involves an 
extra userspace wakeup for every network packet - which is expensive.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
