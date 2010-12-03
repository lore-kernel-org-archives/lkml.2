Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab0LCAhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:37:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab0LCAhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:37:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jscUXD5x3P8D++NW7tb98tJsjzB8G/E1SltyvHpofYxxj+l2GhqdzERK6TqFMsRtMC
         5gW7K/M4X/i8/LCkzsTg==
Date: Thu, 2 Dec 2010 16:37:21 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Ondrej Zary <linux@rainbow-software.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM / Hibernate: Fix memory corruption related to swap
In-Reply-To: <20101202155453.92e8ca57.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1012021622370.26812@tigran.mtv.corp.google.com>
References: <201012030040.37273.rjw@sisk.pl> <20101202155453.92e8ca57.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Andrew Morton wrote:
> On Fri, 3 Dec 2010 00:40:36 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > This patch is a fix for a regression and nasty memory corruption, so I'd like
> > to push it to Linus for 2.6.37 if there are no objections.

(It will need backport to 2.6.35-stable and 2.6.36-stable:
IIRC it doesn't quite apply cleanly to those, so we'll need
to send a separate version.)

> 
> It looks OK to me for 2.6.37 but for 2.6.38 please let's make
> everything here a 100% no-op for CONFIG_PM_SLEEP=n builds. 
> Specifically the slight overhead in __alloc_pages_nodemask.

I expect you're right that the CONFIG_PM would better be CONFIG__PM_SLEEP;
but I think you misunderstand gfp_allowed_mask in __alloc_pages_nodemask:
it came from slab & slub, to fix some early bootup issues, and predates
Rafael's recent use of it in suspend and hibernation.

> 
> Because given the global nature of saved_gfp_mask and the unlocked way
> in which it is accessed, this facility won't be at all useful for
> anything other than suspend.

... and bootup.

Hugh
