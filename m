Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3ABSSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:18:05 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57360 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3ABSSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:18:01 -0500
Message-ID: <50E479AD.9030502@linux.vnet.ibm.com>
Date: Wed, 02 Jan 2013 10:17:17 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 7/8] zswap: add to mm/
References: <<1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>> <<1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>> <0e91c1e5-7a62-4b89-9473-09fff384a334@default> <50E32255.60901@linux.vnet.ibm.com> <50E4588E.6080001@linux.vnet.ibm.com> <28a63847-7659-44c4-9c33-87f5d50b2ea0@default>
In-Reply-To: <28a63847-7659-44c4-9c33-87f5d50b2ea0@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010218-4834-0000-0000-000002242D7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 09:26 AM, Dan Magenheimer wrote:
> However if one compares the total percentage
> of RAM used for zpages by zswap vs the total percentage of RAM
> used by slab, I suspect that the zswap number will dominate,
> perhaps because zswap is storing primarily data and slab is
> storing primarily metadata?

That's *obviously* 100% dependent on how you configure zswap.  But, that
said, most of _my_ systems tend to sit with about 5% of memory in
reclaimable slab which is certainly on par with how I'd expect to see
zswap used.

> I don't claim to be any kind of expert here, but I'd imagine
> that MM doesn't try to manage the total amount of slab space
> because slab is "a cost of doing business".  However, for
> in-kernel compression to be widely useful, IMHO it will be
> critical for MM to somehow load balance between total pageframes
> used for compressed pages vs total pageframes used for
> normal pages, just as today it needs to balance between
> active and inactive pages.

The issue isn't about balancing.  It's about reclaim where the VM only
cares about whole pages.  If our subsystem (zwhatever or slab) is only
designed to reclaim _parts_ of pages, can we be successful in returning
whole pages to the VM?

The slab shrinkers only work on parts of pages (singular slab objects).
 Yet, it does appear that they function well enough when we try to
reclaim from them.  I've never seen a slab's sizes spiral out of control
due to fragmentation.

