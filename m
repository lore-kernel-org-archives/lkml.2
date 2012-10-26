Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2JZDxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:53:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50597 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab2JZDxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:53:01 -0400
Date: Fri, 26 Oct 2012 04:52:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] firmware loader: introduce module parameter to
 customize fw search path
Message-ID: <20121026035259.GO2616@ZenIV.linux.org.uk>
References: <1351212379-26026-1-git-send-email-ming.lei@canonical.com>
 <CA+55aFwaLnyYFaydxw1ALmp_EP217DmgY=ihNy3z1ZqF-pqkSA@mail.gmail.com>
 <CACVXFVObmYD9iG1yMkCNqfdx-XxMKOJ41kAROyxx-RBDufKKmQ@mail.gmail.com>
 <CA+55aFzoJULimHhYHdb-BW1bqSAY8FUevPnYu-K6nDa7xRtg2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzoJULimHhYHdb-BW1bqSAY8FUevPnYu-K6nDa7xRtg2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 08:38:25PM -0700, Linus Torvalds wrote:

> It's valid to cast a non-const pointer to a const one. It's the
> *other* way around that is invalid.
> 
> So marking fw_path[] as having 'const char *' elements just means that
> we won't be changing those elements through the fw_path[] array
> (correct: we only read them). The fact that one of those same pointers
> is then also available through a non-const pointer variable means that
> they can change through *that* pointer, but that doesn't change the
> fact that fw_path[] itself contains const pointers.
> 
> Remember: in C, a "const pointer" does *not* mean that the thing it
> points to cannot change. It only means that it cannot change through
> *that* pointer.

It's a bit trickier, unfortunately - pointer to pointer to const char
and pointer to pointer to char do not mix.  Just for fun, try to constify
envp and argv arguments of call_usermodehelper()...
