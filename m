Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0EFJOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:14:40 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:47841 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0EFJOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:14:38 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some accesspoint == hardlock
Date: Thu, 6 May 2010 11:14:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-self-00106-gd93ac51-dirty; KDE/4.3.4; x86_64; ; )
Cc: NilsRadtkelkml@think-future.de, linux-kernel@vger.kernel.org,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org
References: <20100503191756.GA3479@localhost> <20100503192219.GE25748@tuxdriver.com>
In-Reply-To: <20100503192219.GE25748@tuxdriver.com>
Organization: IBM
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005061114.35480.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 03 Mai 2010 21:22:19 schrieb John W. Linville:
> >   /* Sanity-check TPT calculations */
> >   BUG_ON(window->average_tpt != ((window->success_ratio *
> >       tbl->expected_tpt[index] + 64) / 128));
> 
> Interestingly enough, we have been discussing this line of code today.  Could you try the patch here?
> 
> 	http://marc.info/?l=linux-wireless&m=127290931304496&w=2

I also see a hard lockup some time after connection to my companies
wireless network. My private network does not seem to trigger that bug.
Unfortunately the kernel is not able to switch back graphics, so I 
cannot tell if I see the same BUG - even if the problem description is 
the same.
For reference, the patch above  does not help on my T61p.

It started soon after 2.6.34-rc4. Before and with rc4 I had to
apply this http://patchwork.ozlabs.org/patch/49850/mbox/ patch to avoid
the other crash. With only this patch on top of rc4 everything seemed to
work fine, so the lockup seems to be triggered by one of the other patches.
Sometimes it takes some minutes to crash, which makes it hard to bisect
the problem.

Christian
