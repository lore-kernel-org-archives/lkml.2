Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2EEGuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:50:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2EEGuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:50:10 -0400
Date: Fri, 4 May 2012 23:48:47 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max17042_battery: Fix power supply and irq registration
 ordering
Message-ID: <20120505064846.GA4227@lizard>
References: <1336167517-29092-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336167517-29092-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 03:08:37AM +0530, Ramakrishna Pallala wrote:
> IRQ registration should happen only after power supply object usable.
> This patch fixes the ordering of power supply and irq registration
> calls.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thank you!

And I noticed another small issue: if request_threaded_irq() fails,
we continue with probing (which is OK), but since request failed,
during max17042_remove() and suspend/resume we would call IRQ
routines on a non-requested IRQ.

So, probably you'd want to set client->irq = 0 when request_irq
fails.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
