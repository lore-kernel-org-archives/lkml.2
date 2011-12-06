Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1LFRbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:31:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:54241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LFRbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:31:32 -0500
Message-Id: <20111206171534.429636558@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 06 Dec 2011 18:15:34 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: [PATCH 0/3] Use jump_label for sched_feat()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches implement sched_feat() using jump_labels. The first is a section
mismatch fix. The second patch provides a little infrastructure and the third
patch applies it to make sched_feat() use static_branch().

It uses static_branch() coupled with unlikely/likely in order to control the
branch block position. I haven't checked if it works, but it likely doesn't,
although it should.


