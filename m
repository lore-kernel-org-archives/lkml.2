Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1ASAlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:41:06 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38633 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab1ASAlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:41:04 -0500
Date: Wed, 19 Jan 2011 00:40:40 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: rcu annotation fixup
Message-ID: <20110119004040.GE18984@csn.ul.ie>
References: <20110118110845.GA11555@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110118110845.GA11555@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 01:08:45PM +0200, Michael S. Tsirkin wrote:
> When built with rcu checks enabled, vhost triggers
> bogus warnings as vhost features are read without
> dev->mutex sometimes.
> Fixing it properly is not trivial as vhost.h does not
> know which lockdep classes it will be used under.
> Disable the warning by stubbing out the check for now.
> 

What is the harm in leaving the bogus warnings until the difficult fix
happens? RCU checks enabled does not seem like something that is enabled
in production. If this patch is applied, there is always the risk that
it'll be simply forgotten about.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
