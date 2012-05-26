Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2EZQj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 12:39:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:50057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2EZQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 12:39:57 -0400
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in
 tty_lock_pair(v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <CACVXFVNBiXxVvRWxnXiKPRm5dkj6qziFtXA_OH5kYFg4GZ+-pQ@mail.gmail.com>
References: <1338000869-15129-1-git-send-email-ming.lei@canonical.com>
	 <1338016564.14636.4.camel@twins>
	 <CACVXFVNBiXxVvRWxnXiKPRm5dkj6qziFtXA_OH5kYFg4GZ+-pQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 May 2012 18:39:45 +0200
Message-ID: <1338050385.10390.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 17:23 +0800, Ming Lei wrote:
> 
> You mean that the below is good usage of lock?
> 
>         LOCK A
>         LOCK B
> 
>         UNLOCK A
>         UNLOCK B 

Yep, nothing wrong with that. Its lock order that matters, unlock very
much not so.

