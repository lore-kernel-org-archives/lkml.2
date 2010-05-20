Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0ETSda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:33:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:16159 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab0ETSd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,272,1272870000"; 
   d="scan'208";a="569102879"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100520121518.GA2757@localhost>
References: <20100513150504.GB7535@localhost>
	 <1274138381.2091.4864.camel@rchatre-DESK> <20100520121518.GA2757@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 11:33:28 -0700
Message-ID: <1274380408.2091.9272.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 05:15 -0700, Nils Radtke wrote:
> # 
> # To address (1), could you please run with attached debug patch and also
> # enable rate scaling debugging. That will be "modprobe iwlagn
> # debug=0x143fff).
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In function ‘rs_collect_tx_data’:
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c:364: error: ‘priv’ undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c:364: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c:364: error: for each function it appears in.)
> 
> This happens when compiling w/ the patch applied cleanly against .33.3
> I'll try to fix it, then conduct the field test.

Sorry ... and thanks.

>  For the latter, do 
> you need the same kind of log as for the previous one? 

The goal of this patch is to find the reason behind the error
"expected_tpt should have been calculated by now". From what I
understand you only encountered that in one of your tests, not all. Any
test you can run to reproduce that error will be welcome. 

Thinking about your question more ... I believe your previous debug logs
were created with debug flag 0x43fff. For this iteration, please use
debug flag 0x143fff.

>  
> # Regarding (2): This is a common issue in busy environments where AP
> # decides to deathenticate station after it does not receive an ack for
> # data sent after a few retries. Was this test done in busy environment?
> Both. This happens in busy environment as well as in an idle one. Can't tell
> yet whether there're more of those msgs in busy env. I start to feel against 
> Cisco APs..

I don't know ... perhaps these APs have been set up to be strict wrt
delays.

 
> # Regarding (3): Seems like driver is getting a request to scan after a
> # request to remove interface. I am still inquiring about this.
> Probably due to me switching of via RF_KILLSWITCH. But anyway I assume this
> msg should not happen..

Absolutely. What are the exact steps you run when you encounter this
issue?

Reinette



