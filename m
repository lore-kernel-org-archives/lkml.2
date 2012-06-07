Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2FGB3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:29:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2FGB3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:29:03 -0400
Date: Wed, 6 Jun 2012 18:29:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <roland@kernel.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btree: Fix tree corruption in btree_get_prev()
Message-Id: <20120606182938.f8f6178d.akpm@linux-foundation.org>
In-Reply-To: <CAG4TOxNwVYPPP_AL=YZ6LnZZWyp8FUa50aGtgqGjTwnu598-Lw@mail.gmail.com>
References: <1339003047-15734-1-git-send-email-roland@kernel.org>
	<20120606162121.7d8e8f52.akpm@linux-foundation.org>
	<CAG4TOxPHXg_cDpG2gMNKgyNGs2BcXbM3bTgiuS+mjnPZFhbD8A@mail.gmail.com>
	<CAG4TOxNwVYPPP_AL=YZ6LnZZWyp8FUa50aGtgqGjTwnu598-Lw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012 17:44:20 -0700 Roland Dreier <roland@kernel.org> wrote:

> On Wed, Jun 6, 2012 at 4:36 PM, Roland Dreier <roland@kernel.org> wrote:
> > On the other hand, your change makes me think we don't
> > even need a separate iterator (and we can avoid the variable
> > length array declaration)
> 
> FWIW with that change on top of my patch, I see
> 
> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-123 (-123)
> function                                     old     new   delta
> btree_get_prev                               646     523    -123
> 
> on x86-64, so avoiding the variable length array is definitely
> worth something.
> 
> So the issue for me is whether messing with the caller's
> __key storage is OK, or if it's worth having a temporary
> local variable.
> 

Sometimes altering the caller's *__key when lookup fails is pretty rude
behavior :(

Perhaps we could add an arg to btree_get_prev(), provide it with
separate input and output key pointers?
