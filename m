Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1KDMhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:37:25 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42723 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab1KDMhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:37:23 -0400
Message-Id: <1320410241.2753.140660994612073@webmail.messagingengine.com>
X-Sasl-Enc: TbgVB+d9MMGTlKebP7gQ93mTD44FtARkCo/LQG5AdXeH 1320410241
From: "Clayton Weaver" <cgweav@fastmail.fm>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Date: Fri, 04 Nov 2011 05:37:21 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"So where I can I buy Network Attached Ram and skip all of
this byzantine VM complication?"

So let me see if I have this right: when the frontswap
back end fills up, the current design would force dumping
newer pages to real on-disk swap (to avoid OOM), possibly
compressed, while keeping older pages in the compressed
ram swap cache? It seems like it should just dump
(blocksize/pagesize) * pagesize multiples of its oldest
compressed pages to disk instead and store and compress
the new pages that are submitted to it, thus preserving
the "least recently used" logic in the frontswap backend.

A backend to frontswap should not be able to fail a put
at all (unless the whole machine or container is OOM and
no physical swap is configured, so the backend contains
no pages and has no space to allocate from).

-- 

Clayton Weaver
cgweav at fastmail dot fm

