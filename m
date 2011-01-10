Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1AJTLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:11:25 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44542 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751606Ab1AJTLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:11:24 -0500
Date: Mon, 10 Jan 2011 13:11:22 -0600
From: Robin Holt <holt@sgi.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 0/4] De-couple sysfs memory directories from memory
 sections
Message-ID: <20110110191122.GN2912@sgi.com>
References: <4D2B4B38.80102@austin.ibm.com>
 <20110110184416.GA18974@kroah.com>
 <4D2B543A.3070609@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B543A.3070609@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> The root of this issue is in sysfs directory creation. Every time
> >> a directory is created a string compare is done against all sibling
> >> directories to ensure we do not create duplicates.  The list of
> >> directory nodes in sysfs is kept as an unsorted list which results
> >> in this being an exponentially longer operation as the number of
> >> directories are created.
> > 
> > Are you sure this is still an issue?  I thought we solved this last
> > kernel or so with a simple patch?
> 
> I'll go back and look at this again.

What I recall fixing is the symbolic linking from the node* to the
memory section.  In that case, we cached the most recent mem section
and since they always were added sequentially, the cache saved a rescan.

Of course, I could be remembering something completely unrelated.

Robin
