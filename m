Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1LLMgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:36:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43709 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab1LLMgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:36:11 -0500
MIME-Version: 1.0
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 12 Dec 2011 13:35:50 +0100
Message-ID: <CAPXgP10gRKAgo1ExkvLyNqceKpGujcov90umPQCRiNJ=qTwU_A@mail.gmail.com>
Subject: question about link_mem_sections()
To: Robin Holt <holt@sgi.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin,

you added find_memory_block_hinted() with:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=63d027a63888e993545d10fdfe4107d543f01bca

I try to understand what's going on here, because we need to switch
away from 'struct sysdev'.

In the loop over the node data you call find_memory_block_hinted() in
a row, which might all take a reference. At the end of the section you
drop only the last reference of the iteration. The code before your
change dropped all references inside the loop.

Could you please explain the intended behaviour?

If all is right, we should at least move the now wrong comment where is belongs.

Thanks,
Kay
