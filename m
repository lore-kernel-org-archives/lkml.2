Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0IOOgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:36:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50423 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab0IOOgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:36:42 -0400
To: dhowells@redhat.com
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: memory barrier question
Message-Id: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 15 Sep 2010 16:36:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to understand memory barriers but not quite succeeding.

Consider the following example:

Start:
	p = NULL;
	x = 0;

CPU1:
	atomic_inc(&x);
	p = &x;

CPU2:
	if (p)
		z = atomic_read(p);

Is it possible to end up with z == 0?  What if there's a lock/unlock
before setting "p"?  What if there's a write barrier before setting
"p"?

Thanks,
Miklos
