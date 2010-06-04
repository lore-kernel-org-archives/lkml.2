Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0FDQ5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:57:40 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:54365 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0FDQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:57:38 -0400
Date: Fri, 4 Jun 2010 18:57:32 +0200
From: Nils Radtke <Nils.Radtke@Think-Future.de>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100604165732.GB28003@localhost>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
References: <20100531201225.GA6327@localhost>
 <1275501085.2091.28873.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275501085.2091.28873.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Reinette,

  BTW, this:
  Jun  3 12:05:43 localhost kernel: [174170.391756] iwlagn 0000:03:00.0: 
    TX Power requested while scanning!
  happened even w/o toggling radio switch, so this seems not uniquely
  related to toggling the radio switch.

On mer 2010-06-02 @ 10-51-25 -0700, reinette chatre wrote: 
# On Mon, 2010-05-31 at 13:12 -0700, Nils Radtke wrote:
# 
# > This line indicates the first timestamp _after_ the crash:
# > May 31 17:35:19 localhost kernel: [   69.488456]
# > 
# > The crash happened after site A and on site B. Just arrived, opened lid and *crash*.
# > 
# > I noticed in iwl-agn-rs.c:2080:
# >   BUG_ON(window->average_tpt != ((window->success_ratio *
# >         tbl->expected_tpt[index] + 64) / 128));
# > Could that be again the point that hit me today when the machine crashed once?
# > Would you mind changing this into a milder WARN? That way I wouldn't hit the wall 
# > that hard. And I would notice it anyway while skimming the logs as we still are on the
# > hunt. It's more maintainable if it's a WARN in the src instead of me patching it w/ any
# > update..
# > 
# > Wasn't this BUG_ON a WARNING in .33.3? (didn't check..)
# 
# Seems like you performed the testing without the patch that we used to
# address the hang issue from the beginning of this thread. Please see
Indeed, that's what it feels like. It is just so annoying, that one..
You can't work w/ the kernel drivers. That's a shame.
BTW, iff the patch for the BUG_ON is in kernel src since 2.6.28, that might
explain a lot of crashes before where I haven't never been able to track it down.
Even more, those days I hadn't a chance to do more on this. Unlike now.

# http://marc.info/?l=linux-wireless&m=127290931304496&w=2 - that thread
# also explains why the patch is not in 2.6.34.
It should definitely and absolutely be merged (change the BUG_ON into WARNING).
Even if, like hypothesized, the bug is hidden elsewhere, a BUG_ON doesn't get
me far, it's killing every chance to advance to a solution. How am I supposed
to investigate w/ the kernel crashing? BTW, I don't like working w/ a Linux
kernel that kills my work regularly, I think that's understandable. If I needed
a break from work, I'd set an alarm.

I've seen a bugreport on this issue on the redhat bts referencing my word about
this BUG_ON only getting hit w/ cisco APs. There's a wide range of AP manufacturers 
out there in the city. But only cisco APs are crashing this driver. Admittedly, only 
on one single location, but anyway it's a cisco. Always the same MAC, unless they 
use to reassign MAC addresses, though.. 

I think it's a tough one, if an AP is able to crash the driver. 

I haven't yet received a comment of yours regarding my many other questions in
my previous message. I am willing to help investigate more, assist in other ways 
than testing only (always only doing testing isn't a way to keep up fun..)

# I think it is time to move this discussion to a bug report so that it
# can be tracked better. Please open a new bug at
# http://bugzilla.intellinuxwireless.org/
As you wish. It's probably a good idea. But I still miss the registration mail
from bz, did register yesterday.

So, please see to it, that the patch rendering the BUG_ON into a
WARNING finds it's way back in.

    Thank you very much,


            Nils Radtke


