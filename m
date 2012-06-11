Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2FKRWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:22:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:56682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2FKRWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:22:17 -0400
Message-ID: <1339435331.31548.19.camel@twins>
Subject: Re: [patch v3] sched: fix select_idle_sibling() induced bouncing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Mon, 11 Jun 2012 19:22:11 +0200
In-Reply-To: <1339433835.7358.30.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
	 <1338906621.6110.30.camel@marge.simpson.net>
	 <1339433835.7358.30.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 18:57 +0200, Mike Galbraith wrote:

> Traversing an entire package is not only expensive, it also leads to tasks
> bouncing all over a partially idle and possible quite large package.  Fix
> that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
> to motivate that one other CPU, if it's busy, tough, it may then try it's
> SMT sibling, but that's all this optimization is allowed to cost.
> 
> Sibling cache buddies are cross-wired to prevent bouncing.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

The patch could do with a little comment on how you achieve the
cross-wiring because staring at the code I go cross-eyed again ;-)

Anyway, I think I'll grab it since nobody seems to have any objections
and the numbers seem good.

PJT any progress on your load-tracking stuff? Arjan is interested in the
avg runtime estimation it has to make the whole wake an idle thing
conditional on.
