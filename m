Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0EJXcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:32:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:8055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982Ab0EJXcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:32:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,203,1272870000"; 
   d="scan'208";a="620539126"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100510183639.GA17523@localhost>
References: <20100510183639.GA17523@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 16:32:04 -0700
Message-ID: <1273534324.2370.6740.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 11:36 -0700, Nils Radtke wrote:
>   Today weather was fine again, finally. So testing with .33.3 w/ the patch applied: 
> 
>   http://marc.info/?l=linux-wireless&m=127290931304496&w=2
> 
> The kernel kernel .32 was still running before it crashed immediately on wireless activation.
> The crash log showed again at least two messages, the last was as already described in my first
> message, bug from 2010-04-30: I think even the 0x2030 was the same:
> 
> EIP rs_tx_status +x8f/x2030 

You report an issue on 2.6.32 ...

> 
> W/ .33.3 and the above patch applied:

... but then test the patch with 2.6.33.

Which kernel are you focused on?


> Linux mypole 2.6.33.3 #18 SMP PREEMPT Thu May 6 21:51:37 CEST 2010 i686 GNU/Linux
> 
> May 10 19:14:11 [   80.586637] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
> May 10 19:23:17 [  626.476078] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
> May 10 19:23:30 [  638.913740] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
> May 10 19:23:32 [  641.232425] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
> May 10 19:23:54 [  663.392697] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
> May 10 19:23:58 [  666.980247] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
> May 10 19:24:02 [  671.121826] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now

Can you see any impact on your connection speed that can be connected to
these messages?

> Additionally these were logged, could you tell why they're there and what to do? (also .33.3 w/ patch)
> 
> May 10 19:24:16 [  685.079617] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
> May 10 19:24:22 [  691.026737] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
> May 10 19:28:02 [  911.406162] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
> May 10 19:35:38 [ 1367.251240] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
> 
> The above "iwl_tx_agg_start" lines happen when connecting - again to a Cisco AP - and the connection gets
> dropped the exact moment when a download is started. It even often drops when dhcp is still negotiating, has
> got it's IP but the nego isn't finished yet. Conn drops, same procedure again and again. This happens only
> with this Cisco AP (which is BTW another one from the "expected_tpt should have been calculated by now" 
> problem).

It could be that some of the queues get stuck. Can you try with the
patches in
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2037#c113 ? They
are based on 2.6.33.

Reinette



