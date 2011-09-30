Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1I3X4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:56:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38736 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1I3X4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:56:30 -0400
Date: Fri, 30 Sep 2011 16:56:25 -0700
From: Tejun Heo <htejun@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20110930235625.GD2658@mtj.dyndns.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
 <20110930165206.GA22048@redhat.com>
 <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 30, 2011 at 09:00:23PM +0100, Matt Fleming wrote:
> On Fri, 2011-09-30 at 18:52 +0200, Oleg Nesterov wrote:
> Well, sighand->siglock is seriously overused. It protects so much and I
> think it's pretty confusing. It took me long enough to figure out how
> many locks were really needed. But that's beside the point, having a
> single lock doesn't scale at all, and that's what this series is about.

But scalability for what?  What are the use cases here?  Do we care
enough about benefits to those use cases to accept the increased
complexity?  Having locks with broad coverage isn't necessarily evil.
If things are simpler that way and the protected paths aren't that
hot, who cares?  If splitting the locking makes things simpler, sure
but that doesn't look like the case here, so we need pretty strong
rationale to justify the added complexity.

Thank you.

-- 
tejun
