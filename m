Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1LJKxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 05:53:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1LJKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 05:53:18 -0500
Message-Id: <20111210104341.592561407@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 11:43:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: gregkh@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu
Subject: [PATCH 0/3] kref: inline and barriers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From time to time people on #kernelnewbies ask what the difference is between
kref and using atomic_t yourself. And I keep having to tell them that kref is
the slow and weird option.

These patches try and cure some of that, it inlines all functions and removes
the superfluous memory barriers that are there for no good reason at all.

