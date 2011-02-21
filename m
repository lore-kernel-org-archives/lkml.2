Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1BUTgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:36:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46835 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752237Ab1BUTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:36:34 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+qbZYanwWqBa4BZp+7mG49bR/LxInjWv3VaLgtow
	KPwiQxg/+Akkat
Date: Mon, 21 Feb 2011 20:32:39 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] fsnotify: decouple mark lock and marks fsobject
	lock
Message-ID: <20110221193239.GA32356@lsanfilippo.unix.rd.tt.avira.com>
References: <1298306349-6396-1-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298306349-6396-1-git-send-email-LinoSanfilippo@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The intro was somehow truncated. It should be:

This patch series removes the dependency between holding the lock of a mark and 
holding the lock of the marks fsobject (inode/vfsmount). 
Right now we have to use the following locking order

1. mark lock
2. inode/vfsmount lock

With these patches only one of both locks are taken at the same time, which 
removes the need for a strict locking order.

These patches depend on patch "inotify: fix race when adding a new watch" sent to lkml
on Feb. 11.

Lino
