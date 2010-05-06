Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab0EFQ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:28:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:34905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977Ab0EFQ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:28:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,341,1270450800"; 
   d="scan'208";a="515690589"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "NilsRadtkelkml@think-future.de" <NilsRadtkelkml@think-future.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201005061114.35480.borntraeger@de.ibm.com>
References: <20100503191756.GA3479@localhost>
	 <20100503192219.GE25748@tuxdriver.com>
	 <201005061114.35480.borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 09:28:48 -0700
Message-ID: <1273163328.2226.2530.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Thu, 2010-05-06 at 02:14 -0700, Christian Borntraeger wrote:
> Am Montag 03 Mai 2010 21:22:19 schrieb John W. Linville:
> > >   /* Sanity-check TPT calculations */
> > >   BUG_ON(window->average_tpt != ((window->success_ratio *
> > >       tbl->expected_tpt[index] + 64) / 128));
> > 
> > Interestingly enough, we have been discussing this line of code today.  Could you try the patch here?
> > 
> > 	http://marc.info/?l=linux-wireless&m=127290931304496&w=2
> 
> I also see a hard lockup some time after connection to my companies
> wireless network. My private network does not seem to trigger that bug.
> Unfortunately the kernel is not able to switch back graphics, so I 
> cannot tell if I see the same BUG - even if the problem description is 
> the same.

It will be hard to debug this without some logs. Can you perhaps run
with netconsole for a while? Is it possible to trigger this when not in
X to be able to get some information about where issue is?

> For reference, the patch above  does not help on my T61p.
> 
> It started soon after 2.6.34-rc4. Before and with rc4 I had to
> apply this http://patchwork.ozlabs.org/patch/49850/mbox/ patch to avoid
> the other crash. With only this patch on top of rc4 everything seemed to
> work fine, so the lockup seems to be triggered by one of the other patches.
> Sometimes it takes some minutes to crash, which makes it hard to bisect
> the problem.

Below seven iwlwifi patches were added after rc4. If you are unable to
bisect ... perhaps you can run a while by reverting more and more from
this list?

f2fa1b015e9c199e45c836c769d94db595150731 iwlwifi: correct 6000 EEPROM regulatory address
88be026490ed89c2ffead81a52531fbac5507e01 iwlwifi: fix scan races
8b9fce77737ae9983f61ec56cd53f52fb738b2c7 iwlwifi: work around bogus active chains detection
ece6444c2fe80dab679beb5f0d58b091f1933b00 iwlwifi: need check for valid qos packet before free
de0f60ea94e132c858caa64a44b2012e1e8580b0 iwlwifi: avoid Tx queue memory allocation in interface down
04f2dec1c3d375c4072613880f28f43b66524876 iwlwifi: use consistent table for tx data collect
dd48744964296b5713032ea1d66eb9e3d990e287 iwlwifi: fix DMA allocation warnings

Reinette


