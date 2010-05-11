Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0EKJlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 05:41:50 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:55060 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab0EKJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 05:41:41 -0400
Date: Tue, 11 May 2010 11:41:34 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette.chatre@intel.com
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100511094134.GC9838@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

Thanks a lot for the driver not hanging w/ bug_on() any more. At least the machine 
keeps working and when on battery no repeated reboots are required any more. That alone
already means a lot.

# On Mon, 2010-05-10 at 11:36 -0700, Nils Radtke wrote:
# >   Today weather was fine again, finally. So testing with .33.3 w/ the patch applied: 
# > 
# >   http://marc.info/?l=linux-wireless&m=127290931304496&w=2
# > 
# > The kernel kernel .32 was still running before it crashed immediately on wireless activation.
# > The crash log showed again at least two messages, the last was as already described in my first
# > message, bug from 2010-04-30: I think even the 0x2030 was the same:
# > 
# > EIP rs_tx_status +x8f/x2030 
# 
# You report an issue on 2.6.32 ...
Yes. These errors happened to be the same regardless of .32 or .33

# > W/ .33.3 and the above patch applied:
# 
# ... but then test the patch with 2.6.33.
# 
# Which kernel are you focused on?
Sorry, no intention to confuse or show erratic behaviour.. :)

It's just that the errors occur on both of them. Then I accidently booted the old one again (now
removed from the system), but again, the error showed up on .32, .33{1,2,3} . But you always had
had an indication which kernel it happened on.

OTH, it's basically the same, the identical error persists, so I can't seem the difference here. 
Except for a scientific approach one shouldn't do that, ACK. But, hey, I'd like to use the machine in
the meantime and happened to update the kernel source. 

# > Linux mypole 2.6.33.3 #18 SMP PREEMPT Thu May 6 21:51:37 CEST 2010 i686 GNU/Linux
# > 
# > May 10 19:14:11 [   80.586637] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# > May 10 19:23:17 [  626.476078] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# > May 10 19:23:30 [  638.913740] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# > May 10 19:23:32 [  641.232425] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# > May 10 19:23:54 [  663.392697] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# > May 10 19:23:58 [  666.980247] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# > May 10 19:24:02 [  671.121826] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# Can you see any impact on your connection speed that can be connected to
# these messages?
I'm glad you're asking. Yes, indeed, speed it exceptionally low to what might be achievable. Around 30k/s
average, burst with maybe 200k/s, instead of 700k/s.

# > Additionally these were logged, could you tell why they're there and what to do? (also .33.3 w/ patch)
# > 
# > May 10 19:24:16 [  685.079617] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
# > May 10 19:24:22 [  691.026737] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
# > May 10 19:28:02 [  911.406162] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
# > May 10 19:35:38 [ 1367.251240] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
# > 
# > The above "iwl_tx_agg_start" lines happen when connecting - again to a Cisco AP - and the connection gets
# > dropped the exact moment when a download is started. It even often drops when dhcp is still negotiating, has
# > got it's IP but the nego isn't finished yet. Conn drops, same procedure again and again. This happens only
# > with this Cisco AP (which is BTW another one from the "expected_tpt should have been calculated by now" 
# > problem).
# It could be that some of the queues get stuck. Can you try with the
# patches in
# http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2037#c113 ? They
# are based on 2.6.33.
Good, no wait, bad, now running on .34-rc7. *sigh

I'll apply the patches to .33. .34-rc7 hadn't brought the desired success w/ the olicard100 usb-umts-stick.

Update: noticed you mean 2.6.33 not .33.x ;) On .33.3 it doesn't apply cleanly for a couple of files..
Any objections if I apply it to .33.3 anyway? (Fixing the rej of course..)

Interestingly enough, quilt import 0001*patch imports, quilt push patches but it applies the patch w/o
rej. patch -p1 0001*patch does recognize the patch already applied and rejects..

All patches applied successfully, trying again these days.

Thanks for your comments.

Will keep you informed.

Nils

