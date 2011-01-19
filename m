Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1ASJv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:51:28 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:55424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1ASJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:51:27 -0500
Subject: Re: [2.6.38-rc1] iwlagn lock misuse...
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=DLpfpLYAftktUKa5grNyTeT0-reyjEsrr-NwR@mail.gmail.com>
References: <AANLkTi=DLpfpLYAftktUKa5grNyTeT0-reyjEsrr-NwR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 10:51:22 +0100
Message-ID: <1295430682.4685.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 16:44 +0700, Daniel J Blueman wrote:
> Booting an instrumented 2.6.38-rc1 kernel with an Intel WiFi Link 5300
> card and associating with an access point, I see a lockdep warning
> [attached].
> 
> This is essentially (struct iwl_priv)->lock being taken with
> interrupts disabled in iwl-agn-ict.c:152 [1] and the same lock taken
> with interrupts enabled in rx.c:2476 [2] (confirmed via disassembly).
> 
> It feels like this would have been introduced in this commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6e8cc38d5b05bb812f89a35bd9bf52405e67d0df

I think you're running into a lockdep false positive, it's not actually
the same lock and lockdep confuses a few skb queue locks. Please apply
this patch
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=53c16b8e752e8e58f4313f1155f3afadf78311bb
and see if the problem persists.

johannes

