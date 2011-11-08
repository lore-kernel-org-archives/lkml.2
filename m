Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab1KHP31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:29:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947Ab1KHP3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:29:25 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Rafael J. Wysocki" <rjw@suse.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: khugepaged doesn't want to freeze
Date: Tue,  8 Nov 2011 16:29:10 +0100
Message-Id: <1320766151-2619-1-git-send-email-aarcange@redhat.com>
In-Reply-To: <4EB8E969.6010502@suse.cz>
References: <4EB8E969.6010502@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] thp: reduce khugepaged freezing latency

Beware patch untested but I suspect the problem was the lack of
wakeup during long schedule_timeout. And a missing try_to_freeze in
case alloc_hugepage repeatedly fails in the CONFIG_NUMA=n case.
