Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab2FFXBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:01:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab2FFXBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:01:09 -0400
Date: Wed, 6 Jun 2012 19:00:40 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120606230040.GA18089@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
 <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 03:38:46PM -0700, Linus Torvalds wrote:
 > So what filesystem is this?

The box I saw it on a few days ago: ext4. Today's box: btrfs

 > It really looks like something has left i_mutex locked on a directory,
 > but I'm for the life of me not seeing it. There are lookup changes
 > mainly by Miklos, but they don't seem to change the i_mutex locking.

It is possible that this is a bug stretching back further than 3.4.
I'm continually adding new ways to do terrible things to the fuzzer,
and this last week or so has seen quite a few changes. So maybe I've only
just found a way to tickle this particular bug. (Just like the situation
we had with the mbind corruption a few weeks back).

	Dave

