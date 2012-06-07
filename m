Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2FGAom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:44:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55152 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab2FGAol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAG4TOxPHXg_cDpG2gMNKgyNGs2BcXbM3bTgiuS+mjnPZFhbD8A@mail.gmail.com>
References: <1339003047-15734-1-git-send-email-roland@kernel.org>
 <20120606162121.7d8e8f52.akpm@linux-foundation.org> <CAG4TOxPHXg_cDpG2gMNKgyNGs2BcXbM3bTgiuS+mjnPZFhbD8A@mail.gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 6 Jun 2012 17:44:20 -0700
X-Google-Sender-Auth: vB_lQzUS4ihDKKywpJmkf-XuFg4
Message-ID: <CAG4TOxNwVYPPP_AL=YZ6LnZZWyp8FUa50aGtgqGjTwnu598-Lw@mail.gmail.com>
Subject: Re: [PATCH 1/2] btree: Fix tree corruption in btree_get_prev()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:36 PM, Roland Dreier <roland@kernel.org> wrote:
> On the other hand, your change makes me think we don't
> even need a separate iterator (and we can avoid the variable
> length array declaration)

FWIW with that change on top of my patch, I see

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-123 (-123)
function                                     old     new   delta
btree_get_prev                               646     523    -123

on x86-64, so avoiding the variable length array is definitely
worth something.

So the issue for me is whether messing with the caller's
__key storage is OK, or if it's worth having a temporary
local variable.

 - R.
