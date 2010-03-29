Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0C2PJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:09:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39701 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab0C2PJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:09:50 -0400
Date: Mon, 29 Mar 2010 08:09:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PROVE_RCU breaks proprietary modules (rcu_lock_map)
Message-ID: <20100329150946.GB2569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BA689EA.4050102@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA689EA.4050102@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 10:04:42PM +0100, Tilman Schmidt wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I know there's not much sympathy for troubles with proprietary modules
> here, but the following might save some trouble to kernel developers as
> well as users forced to resort to proprietary drivers:
> 
> Setting the kernel configuration option PROVE_RCU creates a reference to
> the GPL-exported global variable rcu_lock_map even in modules that do
> not use RCU. In the case of non-GPL modules, this leads to a build
> failure because of the license incompatibility.
> (I did not find out where that reference comes from.)
> 
> So if building a proprietary module fails with the message:
> 
> FATAL: modpost: GPL-incompatible module <module> uses GPL-only symbol
> 'rcu_lock_map'
> 
> try rebuilding your kernel with the PROVE_RCU option disabled.
> 
> Hope it helps someone.

I am comfortable with PROVE_RCU being incompatible with non-GPL modules.
After all, it is only a debugging option, not intended for production use.

							Thanx, Paul
