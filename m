Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2KGAiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 19:38:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37442 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KGAiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 19:38:02 -0500
Date: Wed, 7 Nov 2012 00:37:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] /proc/sched_stat and /proc/sched_debug fail at 4096
Message-ID: <20121107003757.GM2616@ZenIV.linux.org.uk>
References: <1352235741-26478-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352235741-26478-1-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 03:02:19PM -0600, Nathan Zimmer wrote:
> When running with 4096 cores attemping to read /proc/sched_stat and
> /proc/sched_debug will fail with an ENOMEM condition.
> On a sufficantly large systems the total amount of data is more then 4mb, so
> it won't fit into a single buffer. 

Not a bad idea, but the iterator is wrong - it assumes that CPU 0 is always
online, AFAICS.  Header should be handled separately - see my reply to
davej several hours ago.
