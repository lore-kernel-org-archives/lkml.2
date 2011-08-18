Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1HRVYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:24:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab1HRVYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:24:00 -0400
MIME-Version: 1.0
In-Reply-To: <1313691091.1107.9.camel@mop>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
 <20110817134516.GA14136@redhat.com> <20110818124353.GA2839@tango.0pointer.de>
 <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Aug 2011 14:23:38 -0700
Message-ID: <CA+55aFxGDbNOhNQJe_LpUMcJCGcW8qFFWzC9H0_KW26Xzb0cXw@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, roland@hack.frob.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 11:11 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
> How about this? It:
> - uses task->real_parent to walk up the chain of parents.

If I read this right, it does that for all the normal cases too.
Disgusting. Slowing down the *usual* UNIX case for your new made-up
case that nobody actually uses is not acceptable.

So NAK. We're not slowing down normal code for some new feature that
realistically will never be used by any normal applications.

                   Linus
