Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0FXGJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:09:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:57884 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0FXGJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:09:43 -0400
Subject: Re: [RFC 1/5] Make soft_irq NMI safe
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 08:09:39 +0200
Message-ID: <1277359779.1875.833.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 11:04 +0800, Huang Ying wrote:
> +#define __raise_softirq_preempt_off(nr)                                        \
> +       do { set_bit(nr, (unsigned long *)local_softirq_pending()); } while (0) 

So that is the reason for that insane local_softirq_pending()
definition?

Quite revolting.
