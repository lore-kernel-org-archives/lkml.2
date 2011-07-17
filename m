Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1GQXjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:39:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755943Ab1GQXjP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110717231610.GR11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com> <20110717231610.GR11013@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Jul 2011 16:38:24 -0700
Message-ID: <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 4:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OR
>
>  - keep part of the patch from Hugh, treating negative in RCU mode as
> "need to unlazy".

No, urgh, that's horrible.

Not being able to do an RCU lookup of negative dentries would be
really sad. There are some loads where a negative dentry is the
*common* case.

                     Linus
