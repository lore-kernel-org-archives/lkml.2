Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0ELOjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:39:11 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50985 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0ELOjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:39:08 -0400
Date: Wed, 12 May 2010 16:39:03 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100512143900.GB6793@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273534324.2370.6740.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

Problem regarding expected tpt calculation: (at site A)
  Tested w/ Linux mypole 2.6.33.3 #21 SMP PREEMPT Tue May 11 11:41:07 CEST 2010 i686 GNU/Linux
  and iwl recovery patches applied.

[28766.975878] iwlagn 0000:03:00.0: loaded firmware version 228.61.2.24
[28770.306101] eth1: direct probe to AP 00:1a:70:aa:bb:cc (try 1)
[28770.506282] eth1: direct probe to AP 00:1a:70:aa:bb:cc (try 2)
[28770.512298] eth1: direct probe responded
[28770.512308] eth1: authenticate with AP 00:1a:70:aa:bb:cc (try 1)
[28770.712518] eth1: authenticate with AP 00:1a:70:aa:bb:cc (try 2)
[28770.714378] eth1: authenticated
[28770.714419] eth1: associate with AP 00:1a:70:aa:bb:cc (try 1)
[28770.914282] eth1: associate with AP 00:1a:70:aa:bb:cc (try 2)
[28770.917618] eth1: RX AssocResp from 00:1a:70:aa:bb:cc (capab=0x401 status=0 aid=2)
[28770.917626] eth1: associated
[28777.113828] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[28777.991207] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[28778.621611] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
[28788.508867] iwlagn 0000:03:00.0: expected_tpt should have been calculated by now

Messages of the type of the last line all over the logs, coming in triples, couples or alone..

Then, there are again these msgs: (site A again)

[29001.505362] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:aa:bb:cc tid = 0
[29039.037933] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1a:70:aa:bb:cc tid = 0

and so on. Associated w/ poor throughput.

  - - -

Problem regarding the deauths/reconnects (sometimes combined w/ bad throughput):

  Tested w/ Linux mypole 2.6.33.3 #21 SMP PREEMPT Tue May 11 11:41:07 CEST 2010 i686 GNU/Linux
  and iwl recovery patches applied.

RFKILL switch on, wpa_cli stat showed auth.

First auth: conn failed during https login

[28018.602587] eth1: deauthenticated from 00:40:96:aa:bb:cc (Reason: 2)
[28018.900400] iwlagn 0000:03:00.0: TX Power requested while scanning!
[28018.900411] iwlagn 0000:03:00.0: Error sending TX power (-11)
[28018.921465] iwlagn 0000:03:00.0: request scan called when driver not ready.

started knoppix download w/ 20k/s avg, got 88kb when:
[28225.669850] eth1: deauthenticated from 00:40:96:aa:bb:cc (Reason: 2)

next try: no deauth but throughput was: --.-K/s
on abortion of wget and retry: deauth:

[28376.132933] eth1: deauthenticated from 00:40:96:aa:bb:cc (Reason: 2)
[28376.253981] eth1: direct probe to AP 00:23:eb:aa:bb:cc (try 1)
[28376.768958] eth1: direct probe to AP 00:23:eb:aa:bb:cc (try 1)
[28376.771879] eth1: direct probe responded
[28376.771887] eth1: authenticate with AP 00:23:eb:aa:bb:cc (try 1)
[28376.971307] eth1: authenticate with AP 00:23:eb:aa:bb:cc (try 2)
[28376.974411] eth1: authenticated
[28376.974455] eth1: associate with AP 00:23:eb:aa:bb:cc (try 1)
[28377.174290] eth1: associate with AP 00:23:eb:aa:bb:cc (try 2)
[28377.180867] eth1: RX AssocResp from 00:23:eb:aa:bb:cc (capab=0x421 status=0 aid=11)
[28377.180875] eth1: associated

Then again, doing nothing:
[28406.222404] eth1: deauthenticated from 00:40:96:aa:bb:cc (Reason: 2)
[28409.836210] eth1: direct probe to AP 00:40:96:aa:bb:cc (try 1)
[28410.036330] eth1: direct probe to AP 00:40:96:aa:bb:cc (try 2)
[28410.039365] eth1: direct probe responded
[28410.039377] eth1: authenticate with AP 00:40:96:aa:bb:cc (try 1)
[28410.239290] eth1: authenticate with AP 00:40:96:aa:bb:cc (try 2)
[28410.245375] eth1: authenticated
[28410.245419] eth1: associate with AP 00:40:96:aa:bb:cc (try 1)
[28410.445346] eth1: associate with AP 00:40:96:aa:bb:cc (try 2)
[28410.448273] eth1: RX AssocResp from 00:40:96:aa:bb:cc (capab=0x421 status=0 aid=17)
[28410.448282] eth1: associated

and so on:
[28476.948459] eth1: deauthenticated from 00:40:96:aa:bb:cc (Reason: 2)
[28477.059629] eth1: direct probe to AP 00:40:96:aa:bb:cc (try 1)
[28477.590389] eth1: direct probe to AP 00:40:96:aa:bb:cc (try 1)
[28477.607096] eth1: direct probe responded
[28477.607106] eth1: authenticate with AP 00:40:96:aa:bb:cc (try 1)
[28477.807275] eth1: authenticate with AP 00:40:96:aa:bb:cc (try 2)
[28477.812340] eth1: authenticated
[28477.812382] eth1: associate with AP 00:40:96:aa:bb:cc (try 1)
[28478.012397] eth1: associate with AP 00:40:96:aa:bb:cc (try 2)
[28478.014914] eth1: RX AssocResp from 00:40:96:aa:bb:cc (capab=0x421 status=0 aid=19)
[28478.014922] eth1: associated

So, this is a real blocker. 

BTW, what is so particular about cisco APs? Again, this is a problem only w/ cisco (different site B, 
though):
0:40:96 Cisco Systems, Inc.

  Thanks.

  Cheers,

            Nils

