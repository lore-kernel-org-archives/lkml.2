Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0D3UtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:49:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab0D3UtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:49:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-aio@kvack.org
Cc: linux-kernel@vger.kernel.org, mjt@tls.msk.ru
Subject: [PATCH 0/2] aio: fix the vectored aio routines
Date: Fri, 30 Apr 2010 16:48:58 -0400
Message-Id: <1272660540-6567-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It was reported[1] that 32 bit readv and writev AIO operations were
not functioning properly.  It turns out that the code to convert the
32bit io vectors to 64 bits was never written.  The results of that
can be pretty bad, but in my testing, it mostly ended up in generating
EFAULT as we walked off the list of I/O vectors provided.

This patch set fixes the problem in my environment.  Comments, as always,
are greatly appreciated.

Cheers,
Jeff

[1] http://lkml.org/lkml/2010/3/8/309

[PATCH 1/2] compat: factor out compat_rw_copy_check_uvector from compat_do_readv_writev
[PATCH 2/2] aio: fix the compat vectored operations

