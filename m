Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2HOPco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab2HOPcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:32:43 -0400
Message-ID: <502BC09A.5050104@redhat.com>
Date: Wed, 15 Aug 2012 11:30:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives
 to balloon pages
References: <20120813084123.GF14081@redhat.com> <20120814182244.GB13338@t510.redhat.com> <20120814195139.GA28870@redhat.com> <20120814195916.GC28870@redhat.com> <20120814200830.GD22133@t510.redhat.com> <20120814202401.GB28990@redhat.com> <20120814202949.GF22133@t510.redhat.com> <20120814204906.GD28990@redhat.com> <20120814205426.GA29162@redhat.com> <502ABB9B.90108@redhat.com> <20120814213832.GA29180@redhat.com>
In-Reply-To: <20120814213832.GA29180@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 05:38 PM, Michael S. Tsirkin wrote:

> And even ignoring that, global pointer to a device
> is an ugly hack and ugly hacks tend to explode.
>
> And even ignoring estetics, and if we decide we are fine
> with a single balloon, it needs to fail gracefully not
> crash like it does now.

Fair enough.  That certainly seems easy enough to fix.

Each balloon driver can have its own struct address_space,
and simply point mapping->host (or any of the others) at
a global balloon thing somewhere.

if (page->mapping && page->mapping->host == balloon_magic)


