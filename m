Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0JJQXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 12:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0JJQXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 12:23:08 -0400
Date: Sun, 10 Oct 2010 12:22:57 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010162257.GA1272@redhat.com>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1DD1A.5080906@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milan,

I'll help cut through this as best I can.  I'm new to this work so I
first need to get up to speed.

I'm just providing my early thoughts below...

On Sun, Oct 10 2010 at 11:34am -0400,
Milan Broz <mbroz@redhat.com> wrote:

> On 10/10/2010 03:08 PM, Andi Kleen wrote:
> > I did it intentionally not split up because a split up is unlikely
> > to be bisectable. I think there is no need for any splitups.
> 
> Shrug. The main encryption thread and ESSIV per-cpu are two separate
> things from my point of view.

Milan, are your split patches equivalent to Andi's new single v3 patch
here?: https://patchwork.kernel.org/patch/244031/

I'd imagine there may be some differences.

> Anyway, the ball is on DM maintainer's playground now.

If there are differences then seems its not for DM maintainers to sort
this out quite yet.  You have 4 patches yet you say conceptually there
are 2 distinct changes.

At a minimum I think your patch 1 and 2 need to be merged if patch 1 on
its own results in "using one tfm is not safe, fixed by foollowing
patch."

If in the end the split patches can be made identical to Andi's v3
patch, then I'm inclined to agree that splitting the single v3 patch
makes sense: if it really is doing multiple distinct changes in one.

But any of Andi's changes in his v3 patch need to be folded back into
your split patchset.  And then your (3?) split patches need to be posted
to dm-devel with both Andi's and your Signed-off-by.

If you feel you shouldn't be doing any more to your split patches then
I'll review all of this closer tomorrow.

Thanks,
Mike
