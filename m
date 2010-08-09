Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab0HIUGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:06:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075Ab0HIUG3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:06:29 -0400
MIME-Version: 1.0
In-Reply-To: <4C596D21.4080101@kernel.org>
References: <4C596D21.4080101@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Aug 2010 13:05:31 -0700
Message-ID: <AANLkTimfmJsUSMw9AuOo3sf_n8hUUMDqvAD13FhZZans@mail.gmail.com>
Subject: Re: [GIT PULL] workqueue for v2.6.36
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Garzik <jeff@garzik.org>, David Howells <dhowells@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Steve French <sfrench@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Walls <awalls@radix.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 6:37 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Please consider pulling from
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

Hmm. So I pulled, because I think it is the right thing in the long
run. But right now I'm bisecting a non-booting machine, and it seems
to be due to the workqueue pull.

It's not fully bisected yet, but the only remaining thing I actually
enable is workqueues. The symptom is a machine that stops at

  ...
  dracut: Starting plymouth daemon
  dracut: Scanning devices sda2  for LVM volume groups
  dracut: Reading all physical volumes. This may take a while...
  dracut: Found volume group "VolGroup" using metadata type lvm2

and the next thing I'd expect to see is the mounting of the filesystem
and the SElinux notifications. And I never do.

I'll bisect it all the way, but thought I'd let you know.

                               Linus
