Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2D0VxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:53:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2D0VxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:53:04 -0400
Date: Fri, 27 Apr 2012 14:53:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/4] compiler.h: introduce unused_expression() macro
Message-Id: <20120427145302.64f50e5c.akpm@linux-foundation.org>
In-Reply-To: <4F9A6CFA.8040805@openvz.org>
References: <20120425112623.26927.43229.stgit@zurg>
	<20120426152909.b1e653bf.akpm@linux-foundation.org>
	<4F9A6CFA.8040805@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 13:55:06 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Andrew Morton wrote:
> > On Wed, 25 Apr 2012 15:26:23 +0400
> > Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
> 
> for example  VM_BUG_ON(!PageCompound(page) || !PageHead(page)); in
> do_huge_pmd_wp_page() generates 114 bytes.
> 
> But they mostly disappears if I replace it with
> -VM_BUG_ON(!PageCompound(page) || !PageHead(page));
> +VM_BUG_ON(!PageCompound(page));
> +VM_BUG_ON(!PageHead(page));
> weird...
> 
> add/remove: 0/0 grow/shrink: 7/97 up/down: 135/-1784 (-1649)

OK, thanks.  I'm inclined to apply the patchset as-is.  If the
apparently mythical use of side-effects in VM_BUG_ON() really exist
then we deserve everything which happens to us as a result ;)

Please update the changelogs so they cover all the points which have been
discussed, add my little code comment then send out a v2, being sure to
cc everyone who has been involved in the discussion?

