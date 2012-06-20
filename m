Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2FTDcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:32:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56846 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2FTDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:32:52 -0400
Date: Tue, 19 Jun 2012 20:31:03 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: "'Nikolaus Voss'" <n.voss@weinmann.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/power/sbs-battery.c: don't trigger false
 supply_changed event
Message-ID: <20120620033103.GA18365@lizard>
References: <201205090803.q4983lYa013593@gatekeeper.vosshq.de>
 <2C89F4165782854891CDE0F3198B753C14F523E30A@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2C89F4165782854891CDE0F3198B753C14F523E30A@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:51:05AM -0700, Rhyland Klein wrote:
> On Wed, 2012-05-09 at 2:31, Nikolaus Voss wrote:
> >power_supply_changed() events are triggerd based on the return value
> >of a get_property() call. However the property TECHNOLOGY is
> >hard-coded to LION in this driver, thus always succeeds.
> >
> >So, with the battery removed, this triggers a false battery present
> >uevent. This uevent triggers a new query via power_supply_uevent()
> >which again starts to query all known properties and thus leads to
> >an infinite loop of battery present/not-present uevents.
> >
> >This patch skips the battery presence detection for the hard-coded
> >property TECHNOLOGY.
> >
> >Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> 
> Acked-by Rhyland Klein <rklein@nvidia.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
