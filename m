Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab0EJSgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:36:53 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:44854 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab0EJSgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:36:51 -0400
Date: Mon, 10 May 2010 20:36:39 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100510183639.GA17523@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503192219.GE25748@tuxdriver.com>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi John,

  Today weather was fine again, finally. So testing with .33.3 w/ the patch applied: 

  http://marc.info/?l=linux-wireless&m=127290931304496&w=2

The kernel kernel .32 was still running before it crashed immediately on wireless activation.
The crash log showed again at least two messages, the last was as already described in my first
message, bug from 2010-04-30: I think even the 0x2030 was the same:

EIP rs_tx_status +x8f/x2030 




W/ .33.3 and the above patch applied:

Linux mypole 2.6.33.3 #18 SMP PREEMPT Thu May 6 21:51:37 CEST 2010 i686 GNU/Linux

May 10 19:14:11 [   80.586637] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
May 10 19:23:17 [  626.476078] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
May 10 19:23:30 [  638.913740] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
May 10 19:23:32 [  641.232425] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
May 10 19:23:54 [  663.392697] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
May 10 19:23:58 [  666.980247] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
May 10 19:24:02 [  671.121826] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now


Additionally these were logged, could you tell why they're there and what to do? (also .33.3 w/ patch)

May 10 19:24:16 [  685.079617] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
May 10 19:24:22 [  691.026737] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
May 10 19:28:02 [  911.406162] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0
May 10 19:35:38 [ 1367.251240] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:12:23:25 tid = 0

The above "iwl_tx_agg_start" lines happen when connecting - again to a Cisco AP - and the connection gets
dropped the exact moment when a download is started. It even often drops when dhcp is still negotiating, has
got it's IP but the nego isn't finished yet. Conn drops, same procedure again and again. This happens only
with this Cisco AP (which is BTW another one from the "expected_tpt should have been calculated by now" 
problem).



Another type occurred: (probably .33.2 or something)

May  3 17:58:11 [ 3946.608743] iwlagn 0000:03:00.0: request scan called when driver not ready.
May  3 17:58:12 [ 3948.082684] iwlagn 0000:03:00.0: TX Power requested while scanning!
May  3 18:01:00 [ 4115.282852] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.

Is this "TX Power requested while scanning" because of RF_KILL set to off?



  Thank you,

  Nils

