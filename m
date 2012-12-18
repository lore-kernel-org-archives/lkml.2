Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2LRBlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:41:44 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:64329 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab2LRBln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:41:43 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 20:41:42 EST
MIME-Version: 1.0
In-Reply-To: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
Date: Tue, 18 Dec 2012 09:34:17 +0800
Message-ID: <CACVXFVNQvwHvJcSzqKv27MH_RgM=e0VvXkLPKCB0i3=Z9_9EXg@mail.gmail.com>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
From: Ming Lei <tom.leiming@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:10 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> I want to change inode->i_flags access to be atomic -- there are some
> locking oddities right now, I think, and I want to use a new inode
> flag to signal mtime updates from page_mkwrite.  The problem is that
> i_flags is an unsigned int, and making it an unsigned long seems like
> a waste, but there aren't any u32 atomic bitops.

See below in include/linux/types.h

typedef struct {
        int counter;
} atomic_t;

#ifdef CONFIG_64BIT
typedef struct {
        long counter;
} atomic64_t;
#endif



Thanks,
-- 
Ming Lei
