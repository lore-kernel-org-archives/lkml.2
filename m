Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1LLP2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:28:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1LLP2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:28:01 -0500
Date: Mon, 12 Dec 2011 07:24:41 -0800
From: Greg KH <gregkh@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
Message-ID: <20111212152441.GA7827@suse.de>
References: <1323529084.16764.5.camel@twins>
 <CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
 <1323546551.2822.14.camel@laptop>
 <CACVXFVNAAXAWtTncahb=sADHxmZOmdDOJA1FUX8Qt4ZR3To_qg@mail.gmail.com>
 <1323607627.16764.13.camel@twins>
 <CACVXFVOYj+Mmph8WGQUdcGS8t-GPr9y3crPuz0SrBCtOmCvstQ@mail.gmail.com>
 <1323617738.16764.21.camel@twins>
 <1323636148.16764.44.camel@twins>
 <CACVXFVMDEeDBkAdv=AkRZuOH1sNdMGjR3PeHYMVLhwR+FB8gOg@mail.gmail.com>
 <1323680157.16764.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323680157.16764.47.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:55:57AM +0100, Peter Zijlstra wrote:
> On Mon, 2011-12-12 at 11:48 +0800, Ming Lei wrote:
> > We can't assume any lock about kref usage, because kref is often used
> > in lockless scenario. 
> 
> Then you're doing it wrong, seriously.
> 
> kref in lockless scenarios simply doesn't work, you need rcu (or another
> means to stabilize storage) and atomic_inc_not_zero() as well as means
> to validate your object after the lookup.

I agree, and I'll apply your patches later today, thanks for doing them.

greg k-h
