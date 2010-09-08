Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0IHRv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:51:29 -0400
Received: from fieldses.org ([174.143.236.118]:37671 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab0IHRvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:51:23 -0400
Date: Wed, 8 Sep 2010 13:50:32 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trond.Myklebust@netapp.com
Subject: Re: nfsd deadlock, 2.6.36-rc3
Message-ID: <20100908175032.GA816@fieldses.org>
References: <4C7E73CB.7030603@canonical.com>
 <20100901165400.GB1201@fieldses.org>
 <20100902065551.079e297c@notabene>
 <4C7EC17B.6070509@canonical.com>
 <20100901211321.GC10507@fieldses.org>
 <4C7FBF26.3090203@canonical.com>
 <4C87BF63.3070808@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C87BF63.3070808@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:52:51AM -0600, Tim Gardner wrote:
> The solution appears to be to twiddle with
> /proc/sys/vm/min_free_kbytes and /proc/sys/vm/drop_caches, though
> I'm not sure this addresses the root cause. Perhaps low memory
> really is the root cause.
> 
> At any rate, their solution was to set min_free_kbytes to 4GB, and
> to 'echo 1 > /proc/sys/vm/drop_caches' whenever free memory fell
> below 8GB. Not particularly elegant, but it appears to have stopped
> their server from wedging.

That does sound like a workaround rather than a fix.  Were there any
diagnostics left in the logs after the lockups?  Could you get sysrq-t
dumps and figure out what was waiting on what?  If the system was too
wedged for any of that to work, would any fo the watchdog deubgging
options help?

--b.
