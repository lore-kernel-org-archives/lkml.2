Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab1FWC3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:29:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46793 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab1FWC3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:29:15 -0400
Date: Thu, 23 Jun 2011 04:29:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW prefetch
Message-ID: <20110623022911.GM3263@one.firstfloor.org>
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com> <m2fwn13a3u.fsf@firstfloor.org> <C10D3FB0CD45994C8A51FEC1227CE22F239E8E4106@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C10D3FB0CD45994C8A51FEC1227CE22F239E8E4106@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 09:01:19AM +0800, Ma, Ling wrote:
> Yes, I also have tested 64bit atom, it got 11.6% improvement.

That's a nice improvement, however I should add that in my experience 
copy_page micro benchmark improvements do not necessarily translate to
real world improvements. Most simple micro benchmark do not simulate
the typical page fault access pattern very well.

> Because older CPU almost all use prefetch-next-line mechanism, the patch should be useful to them.

Old in this case is P4 and ancient early stepping K8 only.

-Andi
