Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1HRO2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab1HRO2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:28:06 -0400
Date: Thu, 18 Aug 2011 16:25:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110818142508.GA30959@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com> <20110817134516.GA14136@redhat.com> <20110818124353.GA2839@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818124353.GA2839@tango.0pointer.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, Lennart Poettering wrote:
>
> On Wed, 17.08.11 15:45, Oleg Nesterov (oleg@redhat.com) wrote:
>
> > You should mark the whole process as sub-reaper, not a single thread
> > which does prctl(). The parent/child relationship is process-wide.
>
> Hmm, how would we implement this best? Would it be sufficient to follow
> group_leader pointer to set/get the flag,

You can mark task->group_leader. Or, probably better, task->signal.

INHO, the best option is SIGNAL_SUB_REAPER in signal->flags. But this
is not possible until we cleanup the usage of signal->flags.

> and to follow real_parent

OOPS. I simly can't understand how I managed to miss this. Of course,
in any case you should follow ->real_parent, not ->parent!

Oleg.

