Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab2DYBL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:11:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34969 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab2DYBL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:11:56 -0400
Message-ID: <1335316301.9726.3.camel@ayu>
Subject: Re: [PATCH 2/2] staging:android:fix line over 80 characters issue
 in binders.c this patch fixes line over 80 characters warning that was
 found using checkpatch.pl tool Signed-off-by:Anirudh Bhat
 <abhat38@gmail.com>
From: Calvin Walton <calvin.walton@kepstin.ca>
To: David Howells <dhowells@redhat.com>
Cc: anirudh bhat <abhat38@gmail.com>, arve@android.com,
        chris+android@zenthought.org, hpa@zytor.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        anirudh bhat <anirudhbhat@ubuntu.ubuntu-domain>
Date: Tue, 24 Apr 2012 21:11:41 -0400
In-Reply-To: <14565.1334823778@redhat.com>
References: <1334767915-4870-1-git-send-email-abhat38@gmail.com> <1>
	 <14565.1334823778@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 09:22 +0100, David Howells wrote:
> anirudh bhat <abhat38@gmail.com> wrote:
> 
> > -		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
> > -		       "map pages in userspace, no vma\n", proc->pid);
> > +		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> > +			proc->pid);
> 
> Are these the wrong way round?  Surely these are introducing checkpatch
> warnings rather than curing them?
> 
> If checkpatch is complaining about:
> 
> 	printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
> 	       "map pages in userspace, no vma\n", proc->pid);
> 
> being a string split over multiple lines, then *checkpatch* needs to be fixed.

This check was added to checkpatch on purpose, with the intention of
allowing you to use e.g.
$ git grep 'failed to match pages'
to find out where in the kernel source the message came from. If the
string is split and wrapped, that doesn't work.

This is mentioned as a recommendation in Documentation/CodingStyle as
well:
> Statements longer than 80 columns will be broken into sensible chunks, unless
> exceeding 80 columns significantly increases readability and does not hide
> information. Descendants are always substantially shorter than the parent and
> are placed substantially to the right. The same applies to function headers
> with a long argument list. However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

