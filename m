Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0ETOP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:15:26 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:32844 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0ETOPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:15:24 -0400
Date: Thu, 20 May 2010 14:15:18 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100520121518.GA2757@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
References: <20100513150504.GB7535@localhost>
 <1274138381.2091.4864.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1274138381.2091.4864.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    Hi,

# > Attached the output from the debug-enabled in-tree iwlwifi driver connects.
# To keep track, this is 2.6.33.3.

# So from what I can tell (to summarize your previous emails) there are
# three issues:
# 1) Error messages like: 
# iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# 
# 2) Frequent deaths with code like:
# eth1: deauthenticated from 00:40:96:aa:aa:aa (Reason: 2)
Appropriate misspelling, I assume, no pun intended? ;)

# 
# 3) Error as follows:
# [ 4148.141064] iwlagn 0000:03:00.0: TX Power requested while scanning!
# [ 4148.141070] iwlagn 0000:03:00.0: Error sending TX power (-11)

This is correct.
 
# 
# To address (1), could you please run with attached debug patch and also
# enable rate scaling debugging. That will be "modprobe iwlagn
# debug=0x143fff).
drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In function ‘rs_collect_tx_data’:
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:364: error: ‘priv’ undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:364: error: (Each undeclared identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:364: error: for each function it appears in.)

This happens when compiling w/ the patch applied cleanly against .33.3
I'll try to fix it, then conduct the field test. For the latter, do 
you need the same kind of log as for the previous one? 
 
# Regarding (2): This is a common issue in busy environments where AP
# decides to deathenticate station after it does not receive an ack for
# data sent after a few retries. Was this test done in busy environment?
Both. This happens in busy environment as well as in an idle one. Can't tell
yet whether there're more of those msgs in busy env. I start to feel against 
Cisco APs..
 
# Regarding (3): Seems like driver is getting a request to scan after a
# request to remove interface. I am still inquiring about this.
Probably due to me switching of via RF_KILLSWITCH. But anyway I assume this
msg should not happen..

Thanks, Reginette.


      Cheers,

              Nils

