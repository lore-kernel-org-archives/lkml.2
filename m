Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0EKPuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:50:21 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:38251 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0EKPuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:50:19 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some accesspoint == hardlock
Date: Tue, 11 May 2010 17:50:08 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-self-00018-g05dc687; KDE/4.3.4; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "NilsRadtkelkml@think-future.de" <NilsRadtkelkml@think-future.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20100503191756.GA3479@localhost> <201005061114.35480.borntraeger@de.ibm.com> <1273163328.2226.2530.camel@rchatre-DESK>
In-Reply-To: <1273163328.2226.2530.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005111750.08533.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 06 Mai 2010 18:28:48 schrieb reinette chatre:
> Below seven iwlwifi patches were added after rc4. If you are unable to
> bisect ... perhaps you can run a while by reverting more and more from
> this list?
> 
> f2fa1b015e9c199e45c836c769d94db595150731 iwlwifi: correct 6000 EEPROM regulatory address
> 88be026490ed89c2ffead81a52531fbac5507e01 iwlwifi: fix scan races
> 8b9fce77737ae9983f61ec56cd53f52fb738b2c7 iwlwifi: work around bogus active chains detection
> ece6444c2fe80dab679beb5f0d58b091f1933b00 iwlwifi: need check for valid qos packet before free
> de0f60ea94e132c858caa64a44b2012e1e8580b0 iwlwifi: avoid Tx queue memory allocation in interface down
> 04f2dec1c3d375c4072613880f28f43b66524876 iwlwifi: use consistent table for tx data collect
> dd48744964296b5713032ea1d66eb9e3d990e287 iwlwifi: fix DMA allocation warnings

Just to give you some feedback. Sometimes it takes a while until it crashes.
My hand made bisect is currently at two remaining patches:

de0f60ea94e132c858caa64a44b2012e1e8580b0
8b9fce77737ae9983f61ec56cd53f52fb738b2c7

reverting both solves my hard lockup. I will try to isolate the "bad" patch
but this takes some more days since I wont be in the "hazardous environment"
this week.

Christian
