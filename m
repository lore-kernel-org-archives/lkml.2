Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1LVXsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:48:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab1LVXsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:48:37 -0500
Date: Thu, 22 Dec 2011 23:48:30 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
	devices
Message-ID: <20111222234830.GC31021@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
	jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com> <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 02:25:56PM -0800, Linus Torvalds wrote:
> I don't *think* anybody does something as crazy as giving actual block
> device ownership to people, 

That can happen when running virtual machines backed by logical volumes.

Say I am running a server that offers virtual machines to different
people, and I allow those people to have root access within their own
guest, but, naturally, I don't give them any access to other people's
guests.

I pool my disks on the server into a Volume Group and create one simple
Logical Volume per guest VM to hold its filesystem.

Due to this bug, a root user inside one guest VM can see and modify the
contents of other VMs that don't belong to them (and in some situations
perhaps even take control of the host machine by modifying the host's
LVM metadata).

Alasdair

