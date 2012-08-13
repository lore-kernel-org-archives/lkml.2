Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2HMRBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:01:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60321 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2HMRBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:01:14 -0400
Date: Mon, 13 Aug 2012 18:01:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [flame^Wreview] net: netprio_cgroup: rework update socket logic
Message-ID: <20120813170109.GD23464@ZenIV.linux.org.uk>
References: <20120813015348.GZ23464@ZenIV.linux.org.uk>
 <502896C5.7080303@intel.com>
 <50289D7F.3070402@intel.com>
 <20120813121827.GB23464@ZenIV.linux.org.uk>
 <50293224.90803@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50293224.90803@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 09:58:12AM -0700, John Fastabend wrote:
> [...]
> 
> >HOWEVER, it still doesn't address more fundamental problem - somebody
> >creating a socket and passing it to you in SCM_RIGHTS datagram will
> >leave you with a socket you can do IO on, still tagged according to who
> >had created it.
> >
> >AFAICS, the whole point of that exercise was to allow third-party changing
> >the priorities of traffic on sockets already created by a process we now
> >move to a different cgroup.  Consider e.g. this:
> 
> Correct that is the point of the exercise.
> 
> To fix this specific case we could add a call to sock_update_netprioidx
> in scm_recv to set the sk_cgrp_prioidx value.

On every received descriptor, that is?  Eeek...
