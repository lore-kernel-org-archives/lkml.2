Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0KCFRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 01:17:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57591 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0KCFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:17:07 -0400
Date: Wed, 3 Nov 2010 10:46:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        nishimura@mxp.nes.nec.co.jp, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        hughd@gmail.com
Subject: Re: [BUGFIX][PATCH] fix wrong VM_BUG_ON() in try_charge()'s
 mm->owner check
Message-ID: <20101103051647.GK3769@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <AANLkTikCUdpx-jGhKdzueML39CnExumk1i_X_OZJihE2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTikCUdpx-jGhKdzueML39CnExumk1i_X_OZJihE2@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com> [2010-11-03 00:10:50]:

> I'm sorry for attached file, I have to use unusual mailer this time.
> This is a fix for wrong VM_BUG_ON() for mm/memcontol.c
>

Yes, that seems reasonable. If we race with try_to_unuse() and
the mm has no new owner we set mm->owner to NULL, in those cases it
makes no sense to charge.


Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
