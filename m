Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1KRTDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:03:07 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:39913 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab1KRTDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:03:05 -0500
From: Kevin Hilman <khilman@ti.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: <linux-omap@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCHv9 07/18] mfd: omap-prm: added suspend prepare and complete callbacks
Organization: Texas Instruments, Inc.
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
	<1316781986-30642-8-git-send-email-t-kristo@ti.com>
Date: Fri, 18 Nov 2011 11:02:55 -0800
In-Reply-To: <1316781986-30642-8-git-send-email-t-kristo@ti.com> (Tero
	Kristo's message of "Fri, 23 Sep 2011 15:46:15 +0300")
Message-ID: <87d3cpxnhc.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tero Kristo <t-kristo@ti.com> writes:

> These are needed because runtime PM is disabled during suspend, and
> it is bad if we get interrupts from the PRCM chain handler during it.
> Now, PRCM interrupt forwarding is disabled until the suspend->complete,
> which makes sure that all the needed drivers are up.

Just to clarify...  based on reading the patch, the wakeup and PRCM
interrupts themselves still happen (and are saved). They are just not
dispatched to the drivers until ->complete().

I think the changelog should be a bit clearer about that.

Thanks,

Kevin
