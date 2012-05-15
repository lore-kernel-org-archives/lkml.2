Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2EOFCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 01:02:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57584 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2EOFCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 01:02:30 -0400
Date: Tue, 15 May 2012 00:02:21 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [34-longterm 074/179] xen: Use IRQF_FORCE_RESUME
Message-ID: <20120515050221.GA4292@burratino>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
 <1337048075-6132-75-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337048075-6132-75-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Gortmaker wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
[...]
>     If you see a problem with using this for longterm, please comment.
[...]
> commit 676dc3cf5bc36a9e129a3ad8fe3bd7b2ebf20f5d upstream.
>
> Mark the IRQF_NO_SUSPEND interrupts IRQF_FORCE_RESUME and remove the extra
> walk through the interrupt descriptors.

This produces resume failures and migration failures in Xen guests[1].

Commit 9bab0b7fbace (genirq: Add IRQF_RESUME_EARLY and resume such
IRQs earlier, 2011-11-09) is needed on top to avoid regressions.

Hope that helps,
Jonathan

[1] http://thread.gmane.org/gmane.linux.kernel/1198673
