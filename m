Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1K3OJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1K3OJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:09:51 -0500
Date: Wed, 30 Nov 2011 14:09:13 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>
Cc: esandeen@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Message-ID: <20111130140913.GX7595@agk-dp.fab.redhat.com>
Mail-Followup-To: Jan Kara <jack@suse.cz>,
	Mikulas Patocka <mpatocka@redhat.com>, esandeen@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	Valerie Aurora <val@vaaconsulting.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com> <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com> <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com> <20111129101901.GA5635@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129101901.GA5635@quack.suse.cz>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:19:01AM +0100, Jan Kara wrote:
> So I believe the consensus was that we should not block sync or flusher

Consensus where?

> thread on frozen filesystem. Firstly, it's kind of ugly from user
> perspective (you cannot sync filesystems on your system while one
> filesystem is frozen???), secondly, in case of flusher thread it has some
> serious implications if there are more filesystems on the same device - you
> would effectively stop any writeback to the device possibly hanging the
> whole system due to dirty limit being exceeded. So at least in these two
> cases we should just ignore frozen filesystem.

The sync only needs to block on a particular fs if there is data to flush.

A sync that originated in a way that can only be independent of any
application that is changing the fs may skip that fs if it is frozen.

It's the user's responsibility only to freeze filesystems for very brief
periods of time if they are still being changed.

?
 
Alasdair

