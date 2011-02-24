Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1BXCv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 21:51:58 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:53301 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1BXCv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 21:51:57 -0500
Date: Wed, 23 Feb 2011 18:51:52 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness (v3)
Message-ID: <20110223185152.7e3c29a9@queued.net>
In-Reply-To: <20110224024708.GA12139@angua.secretlab.ca>
References: <20110223150357.5a40793d@queued.net>
	<20110223232815.GC5404@angua.secretlab.ca>
	<20110223163442.2974bd66@queued.net>
	<20110224024708.GA12139@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 19:47:08 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Wed, Feb 23, 2011 at 04:34:42PM -0800, Andres Salomon wrote:
> > 
> > Commit e2f2a93b changed dp->name from using the 'name' property to
> > using package-to-path.  This fixed /proc/device-tree creation by
> > eliminating conflicts between names (the 'name' property provides
> > names like 'battery', whereas package-to-path provides names like
> > '/foo/bar/battery@0', which we stripped to 'battery@0').  However,
> > it also breaks of_device_id table matching.
> > 
> > The fix that we _really_ wanted was to keep dp->name based upon
> > the name property ('battery'), but based dp->full_name upon
> > package-to-path ('battery@0').  This patch does just that.
> > 
> > This also changes OLPC behavior to use the full result from
> > package-to-path for full_name, rather than stripping the directory
> > out.  In practice, the strings end up being exactly the same; this
> > change saves time, code, and memory.
> > 
> > v2: combine two patches and revert of_pdt_node_name to original
> > version v3: use dp->phandle instead of passing around node
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> This addresses one of my comments on v2; but it doesn't address the
> comment that the broken implementation of of_pdt_node_name for
> non-sparc still remains, or am I missing something?
> 
> g.
> 


I responded to that -
http://www.spinics.net/lists/sparclinux/msg08058.html
