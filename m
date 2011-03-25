Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1CYGpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 02:45:47 -0400
Received: from lo.gmane.org ([80.91.229.12]:42551 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab1CYGpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 02:45:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [KDUMP] Ignore spurious IPI
Date: Fri, 25 Mar 2011 06:45:25 +0000 (UTC)
Message-ID: <imhdm5$9u8$2@dough.gmane.org>
References: <C3CBE989BE8833indou.takao@jp.fujitsu.com>
	<smp-ipi-supurious-single-kdump@mdm.bga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 222.90.175.22
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kexec@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 08:20:32 -0600, Milton Miller wrote:
> If so, just initialize the data structure earlier -- change
> init_call_single_data from early_initcall to an explict call after the
> per-cpu areas are initialized.
> 

Yeah, this is a good idea, IPI related data structures should be
ready before interrupts are enabled. We should not assume that
there is no IPI pending before init_call_single_data gets initialized,
altough this is true in non-kdump kernel.

Thanks.

