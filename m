Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0FWT4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:56:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707Ab0FWT4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:56:16 -0400
Date: Wed, 23 Jun 2010 12:56:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] vt/console: try harder to print output when panicing
Message-Id: <20100623125605.5f56f6ba.akpm@linux-foundation.org>
In-Reply-To: <1277262779-19338-1-git-send-email-airlied@gmail.com>
References: <1277262779-19338-1-git-send-email-airlied@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 13:12:59 +1000
Dave Airlie <airlied@gmail.com> wrote:

> Jesse's initial patch commit said:
> 
> "At panic time (i.e. when oops_in_progress is set) we should try a bit
> harder to update the screen and make sure output gets to the VT, since
> some drivers are capable of flipping back to it.
> 
> So make sure we try to unblank and update the display if called from a
> panic context."
> 
> I've enhanced this to add a flag to the vc that console layer can set
> to indicate they want this behaviour to occur. This also adds support
> to fbcon for that flag and adds an fb flag for drivers to indicate
> they want to use the support. It enables this for KMS drivers.

Interesting.  Getting real oops traces from machines running X will
make Rusty happy, and that's what we're all here for.

How well does this all work?  How reliable is it?  What's the success rate?



What's the downside here?  After all, not all oopses are catastrophic -
sometimes the machine will go blurt and keep running so the user can
take a look in the logs then perform an orderly reboot, etc.  As I
understand it, those non-catastrophic oopses will now flip the machine
from X and into the vt display, yes?  Can the user get it back to X
mode?

Worse, there's also a risk that doing all this new work within the
oopsing context will screw the machine up, so the user will be
_deprived_ of an oops report which he otherwise would have been able to
get from the logs.  This is particularly the case when it's the DRI
stuff which oopsed, which is not exactly an uncommon occurrence lately ;)

Oh well, the best way to tell is to ship-it-and-see.
