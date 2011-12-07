Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab1LGEu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 23:50:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab1LGEu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 23:50:57 -0500
Date: Wed, 7 Dec 2011 10:20:48 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/12] virtio: balloon: Add freeze, restore handlers
 to support S4
Message-ID: <20111207045048.GA9371@amit-x200.redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <5deccc36afa59032f0e3b10a653773bad511f303.1323199985.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5deccc36afa59032f0e3b10a653773bad511f303.1323199985.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 07 Dec 2011 [01:18:50], Amit Shah wrote:

[snip]

> Now to not race with a host issuing ballooning requests while we are in
> the process of freezing, we just exit from the vballoon kthread when the
> processes are asked to freeze.  Upon thaw and restore, we re-start the
> thread.

Actually this isn't necessary.  I over-zealously killed the thread
when it's not really necessary: the thread is frozen before calling
the freeze() callback and is thawed only after the restore() or thaw()
callbacks are done, so we're exactly in the same state with or without
keeping the kthread around (just that the PID of the kthread will
change).  So I'll back out this change for the next revision.


		Amit
