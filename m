Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab1E1E3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 00:29:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab1E1E3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 00:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=sZV2O9x3cqR1le0TY8M03kJrTEUQYCc+fblTUt1jX2wmPzELzu9/Q32tGC6pFlJzZY
         w7cpDfKucsjMnPCp2VA/OYanIKsV9JcLGA544jfX0illJRAwA7RFm34Ry+e5gbIn+xhV
         1ZA+ApRYCO3Ue0kbWMhOc4zkC+znlylbcMzM8=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm/i915: fix regression after clock gating init split
Date: Sat, 28 May 2011 14:26:28 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r5; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105272344.20084.jasonbstubbs@gmail.com> <yunaae8j5dg.fsf@aiko.keithp.com>
In-Reply-To: <yunaae8j5dg.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281426.28488.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011 05:44:11 Keith Packard wrote:
> On Fri, 27 May 2011 23:44:19 +1000, Jason Stubbs <jasonbstubbs@gmail.com> 
wrote:
> > From: Jason Stubbs <jasonbstubbs@gmail.com>
> > 
> > However, there are some code paths, notably IS_PINEVIEW(dev), where 
> > init_clock_gating is not set and not needed.
> 
> Looks like Pineview should be using the gen3_init_clock_gating function.

Yep, you are right. Adding printk()s to the original implementation confirmed 
that - at least on my hardware. I should have known to check that...

There are two other code paths where an init_clock_gating function isn't 
specified though. The specific code paths are:

HAS_PCH_SPLIT() && !IS_GEN5() && !IS_GEN6() && !IS_IVYBRIDGE()

Looking at the original intel_enable_clock_gating() function, there would
have been some intialization done for this case.

IS_GEN4() && !IS_CRESTLINE() && !IS_BROADWATER()

It looks like this would have gone into the final "no gating match" if/else 
branch.

If both of the above don't happen in the real world, then I guess it's fine as 
is. If either are possible, then they need to be fixed too.

I'll just (re)send a patch for the IS_PINEVIEW() case and leave the above to
somebody who knows better than I...

Regards,
Jason Stubbs
