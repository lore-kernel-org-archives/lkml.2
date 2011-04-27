Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab1D0NWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:22:34 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:60866 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932832Ab1D0NWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:22:32 -0400
Date: Wed, 27 Apr 2011 09:22:19 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        Ian Kent <raven@themaw.net>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Lockdep splat in autofs with 2.6.39-rc2
Message-ID: <20110427132219.GA2843@elliptictech.com>
References: <20110407194403.GA29404@elliptictech.com>
 <20110421212537.GC24898@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421212537.GC24898@home.goodmis.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 17:25 -0400, Steven Rostedt wrote:
> On Thu, Apr 07, 2011 at 03:44:03PM -0400, Nick Bowler wrote:
> > Just saw this on 2.6.39-rc2 after half a day or so of uptime.  I've
> > never seen it before today so it may be a regression from 2.6.38.
> > Nothing seems have failed as a result.  Please let me know if you
> > need any more info.
> 
> Could you try this patch. I know it may be hard to reproduce, but the
> issue is that we are recursing down the locks in a tree/list and we changed a
> lock from being nested to being a parent. This patch tells lockdep about
> what we did.

OK, I've built 2.6.39-rc5 with this patch applied.  However, it took ~5
days before I saw any splat with -rc4, thus it's unlikely that I'll be
able to say for sure that it works.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
