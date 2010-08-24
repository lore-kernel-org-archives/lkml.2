Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0HXIyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:54:23 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:33587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0HXIyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:54:22 -0400
Subject: workqueue destruction BUG_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 10:55:56 +0200
Message-ID: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, all,

In our testing with iwlwifi, we keep running into this BUG_ON:

	BUG_ON(cwq->nr_active);

in destroy_workqueue(). This is quite unhelpful, and since the code
flushes the workqueue I really don't see how this could be happening,
unless maybe there's cross-talk between this and other workqueues?

johannes

