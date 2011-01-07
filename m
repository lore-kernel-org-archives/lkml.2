Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1AGWja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:39:30 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56105 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1AGWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:39:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Ps+rjs7bxw2QxHBuIyjz450/13QbdC8qoZNrXcu2/nLeP8s8nre1yvFWH8tc80JthM
         s4d/ZHj+W9Yt5KbVIdvw==
Date: Fri, 7 Jan 2011 14:39:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ying Han <yinghan@google.com>
cc: Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Randy Dunlap <rdunlap@xenotime.net>, dle-develop@lists.sourceforge.net,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC][PATCH 0/2] Tunable watermark
In-Reply-To: <AANLkTikQPXWkEJwN5fV2vnUS37Fs+GNzFXuFkKXcnzmu@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101071436220.23858@chino.kir.corp.google.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1101071416450.23577@chino.kir.corp.google.com> <AANLkTikQPXWkEJwN5fV2vnUS37Fs+GNzFXuFkKXcnzmu@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Ying Han wrote:

> On the other hand, having the low/high wmark consider more characters
> other than the
> size of the zone sounds useful.

The semantics of any watermark is to trigger events to happen at a 
specific level, so they should be static with respect to a frame of 
reference (which in the VM case is the min watermark with respect to the 
size of the zone).  If you're going to adjust the min watermark, it's then 
_mandatory_ to adjust the others to that frame of reference, you shouldn't 
need to tune them independently.

The problem that Satoru is reporting probably has nothing to do with the 
watermarks themselves but probably requires more aggressive action by 
kswapd and/or memory compaction.
