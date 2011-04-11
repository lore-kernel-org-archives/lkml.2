Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1DKVaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:30:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60432 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab1DKVaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:30:08 -0400
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris McDermott <lcm@linux.vnet.ibm.com>
In-Reply-To: <20110411172004.0361.A69D9226@jp.fujitsu.com>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 11 Apr 2011 14:29:31 -0700
Message-ID: <1302557371.7286.16607.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 17:19 +0900, KOSAKI Motohiro wrote:
> This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> relatively cheap 2-4 socket machine are often used for tradiotional
> server as above. The intention is, their machine don't use
> zone_reclaim_mode.

I know specifically of pieces of x86 hardware that set the information
in the BIOS to '21' *specifically* so they'll get the zone_reclaim_mode
behavior which that implies.

They've done performance testing and run very large and scary benchmarks
to make sure that they _want_ this turned on.  What this means for them
is that they'll probably be de-optimized, at least on newer versions of
the kernel.

If you want to do this for particular systems, maybe _that_'s what we
should do.  Have a list of specific configurations that need the
defaults overridden either because they're buggy, or they have an
unusual hardware configuration not really reflected in the distance
table.

-- Dave

