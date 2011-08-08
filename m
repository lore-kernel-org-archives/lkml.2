Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1HHRFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:05:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1HHRFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:05:35 -0400
Date: Mon, 8 Aug 2011 10:03:00 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [07/55] SUNRPC: Fix a race between work-queue
 and rpc_killall_tasks
Message-ID: <20110808170300.GA27419@suse.de>
References: <20110806000249.573906795@clark.kroah.org>
 <1312738681.2591.1024.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312738681.2591.1024.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 06:38:01PM +0100, Ben Hutchings wrote:
> On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > 
> > commit b55c59892e1f3b6c7d4b9ccffb4263e1486fb990 upstream.
> > 
> > Since rpc_killall_tasks may modify the rpc_task's tk_action field
> > without any locking, we need to be careful when dereferencing it.
> [...]
> 
> This isn't nearly careful enough to avoid races.  You must at least use
> the ACCESS_ONCE macro, otherwise the compiler can just optimise away the
> local variable this introduces.

Well, that's an upstream issue as well, right?  Not much I can do here
in the stable updates :)

greg k-h
