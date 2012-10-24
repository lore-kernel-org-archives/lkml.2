Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425Ab2JXV5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:57:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161269Ab2JXV44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:56:56 -0400
Date: Wed, 24 Oct 2012 14:56:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [RESEND][PATCH] gen_init_cpio: avoid stack overflow when
 expanding
Message-Id: <20121024145655.7db21d20.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jJBLcdfhv8=LNkXZ6h4xsXrDZP094fojnPpJ0OcwnCtSA@mail.gmail.com>
References: <20121024205756.GA12419@www.outflux.net>
	<20121024140227.299041a9.akpm@linux-foundation.org>
	<CAGXu5jK2kNgccbbuadjUFn+bbj9_02HbQfjUDeL4sNz1GWtHEQ@mail.gmail.com>
	<20121024144442.6253965d.akpm@linux-foundation.org>
	<CAGXu5jJBLcdfhv8=LNkXZ6h4xsXrDZP094fojnPpJ0OcwnCtSA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 14:53:33 -0700
Kees Cook <keescook@chromium.org> wrote:

> > Well, I do think that a description of the user impact of the bug
> > should be included in the changelog so that poor old Greg can work out
> > why we sent it at him.
> >
> > If you can suggest some suitable text I can copy-n-slurp that into the
> > changelog.
> 
> How about replacing the first paragraph with:
> 
> Fix possible overflow of the buffer used for expanding environment
> variables when building file list. In the extremely unlikely case of
> an attacker having control over the environment variables visible to
> gen_init_cpio, control over the contents of the file gen_init_cpio
> parses, and gen_init_cpio was built without compiler hardening, the
> attacker can gain arbitrary execution control via a stack buffer
> overflow.

ooh, spiffy - even I understood that!
