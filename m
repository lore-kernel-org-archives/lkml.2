Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2KXQIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 11:08:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2KXQIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 11:08:19 -0500
Date: Sat, 24 Nov 2012 17:08:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Introduce filter_chain()
Message-ID: <20121124160802.GA4942@redhat.com>
References: <20121123202741.GA18858@redhat.com> <20121123202812.GA18897@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123202812.GA18897@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Oleg Nesterov wrote:
>
> Change install_breakpoint() to call filter_chain() instead of checking
> uprobe->consumers != NULL. We obviously need this, and this equally
> closes the race with _unregister().
>
> Change remove_breakpoint() to call this helper too. Currently this is
> pointless because remove_breakpoint() is only called when the last
> consumer goes away, but we will change this.

Just in case...

This is only to make the initial change as simple as possible. filter_chain()
will have more arguments and more callers, say, perhaps build_map_info().
And perhaps these 2 callsites should be moved from install/remove to the
caller later.

Oleg.

