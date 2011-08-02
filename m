Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1HBBWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:22:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527Ab1HBBWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <201108020217.48952.rjw@sisk.pl>
References: <201108020147.01136.rjw@sisk.pl> <201108020217.48952.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Aug 2011 15:22:02 -1000
Message-ID: <CA+55aFxPAowBwgK7JqN0uH-ytvg+BKdE3yBGF0z_6kNDNcOYcQ@mail.gmail.com>
Subject: Re: [Regression] Commit 02c24a82187d5a628c68edfe71ae60dc135cd178
 breaks s2disk
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Josef Bacik <josef@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 2:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, I'm not sure if the patch below is the right fix, but it evidently makes
> s2disk work for me again.

Looks right to me.

The only issue is whether we should use "db_mapping->i_mapping" or
"file->f_mapping". I think they are the same for block devices.

Al?

Also, what about some of the other fsync things that apparently
weren't updated to write back page caches. ps3flash_fsync? Others?

                Linus
