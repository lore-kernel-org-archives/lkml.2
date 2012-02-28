Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2B1Iau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:30:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab2B1Iat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:30:49 -0500
Date: Tue, 28 Feb 2012 00:32:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] consolidate WARN_...ONCE() static variables
Message-Id: <20120228003206.e661f926.akpm@linux-foundation.org>
In-Reply-To: <4F4C9B7802000078000751BC@nat28.tlf.novell.com>
References: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
	<20120227160302.ef9f6af4.akpm@linux-foundation.org>
	<4F4C93520200007800075197@nat28.tlf.novell.com>
	<20120227234451.3a00a76a.akpm@linux-foundation.org>
	<4F4C983002000078000751AE@nat28.tlf.novell.com>
	<20120228001210.26b59479.akpm@linux-foundation.org>
	<4F4C9B7802000078000751BC@nat28.tlf.novell.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 08:16:40 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:

> Oh, sorry - to carry static data the accesses to which are unlikely
> (i.e., as in the case given, fully contained in code sections inside
> conditionals which themselves use unlikely() on their primary/only
> clause - in other words, something that the compiler really could
> do on its own).

I think I just learned more about this patch than at any time since we
started discussing it.

Why add a new section, rather than using __read_mostly?

I suppose we should add and use a #define for this, like __read_mostly.
That would be a good site for documenting it ;)

And I come back to my old friend printk_once().  If I'm understanding
things correctly, we can/should make that test unlikely, then mark
__print_once as __this_new_section?  Otherwise... help!

btw, I don't think there's a significant performance benefit here - if
the kernel is ever executing WARN_ON_ONCE(), WARN_ONCE() or
printk_once() with any frequency then it is already badly broken.

Which brings us down to saving a bit of space.  And I don't think I see
how this saves space?

