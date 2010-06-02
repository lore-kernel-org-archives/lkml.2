Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab0FBRva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:51:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:60176 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab0FBRv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,348,1272870000"; 
   d="scan'208";a="804160985"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100531201225.GA6327@localhost>
References: <20100531201225.GA6327@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 10:51:25 -0700
Message-ID: <1275501085.2091.28873.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 13:12 -0700, Nils Radtke wrote:

> This line indicates the first timestamp _after_ the crash:
> May 31 17:35:19 localhost kernel: [   69.488456]
> 
> The crash happened after site A and on site B. Just arrived, opened lid and *crash*.
> 
> I noticed in iwl-agn-rs.c:2080:
>   BUG_ON(window->average_tpt != ((window->success_ratio *
>         tbl->expected_tpt[index] + 64) / 128));
> Could that be again the point that hit me today when the machine crashed once?
> Would you mind changing this into a milder WARN? That way I wouldn't hit the wall 
> that hard. And I would notice it anyway while skimming the logs as we still are on the
> hunt. It's more maintainable if it's a WARN in the src instead of me patching it w/ any
> update..
> 
> Wasn't this BUG_ON a WARNING in .33.3? (didn't check..)

Seems like you performed the testing without the patch that we used to
address the hang issue from the beginning of this thread. Please see
http://marc.info/?l=linux-wireless&m=127290931304496&w=2 - that thread
also explains why the patch is not in 2.6.34.

I think it is time to move this discussion to a bug report so that it
can be tracked better. Please open a new bug at
http://bugzilla.intellinuxwireless.org/

Reinette



