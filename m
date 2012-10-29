Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300Ab2J2X37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:29:59 -0400
Received: from plane.gmane.org ([80.91.229.3]:47238 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2J2X36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:29:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Osipenko <digetx@gmail.com>
Subject: Re: [PATCH V2] dma: tegra: avoid channel lock up after free
Date: Mon, 29 Oct 2012 23:28:10 +0000 (UTC)
Message-ID: <loom.20121030T002407-501@post.gmane.org>
References: <508EA04D.5050805@wwwdotorg.org> <1351552833-4132-1-git-send-email-digetx@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 91.79.157.67 (Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also code looks not thread-safe, is it ok? For example we can protect prepare
functions with a spinlock and add tegra_dma_terminate_all_locked for calling on
channel freeing under spinlock to avoid reschedule. What do you think?

