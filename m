Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2BGTg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:36:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63637 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BGTg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120207075500.29797.95376.stgit@zurg>
References: <20120207074905.29797.60353.stgit@zurg> <20120207075500.29797.95376.stgit@zurg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Feb 2012 11:36:08 -0800
X-Google-Sender-Auth: qEhQgLJEBYTckXwyB6JUdc1HR7E
Message-ID: <CA+55aFx-NSOmTC73q=zOmQ-i-h2KhzKnGCsyed6Pq2UGWLxiAA@mail.gmail.com>
Subject: Re: [PATCH 1/4] bitops: implement "optimized" __find_next_bit()
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 11:55 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> This patch adds  __find_next_bit() -- static-inline variant of find_next_bit()
> optimized for small constant size arrays, because find_next_bit() is too heavy
> for searching in an array with one/two long elements.
> And unlike to find_next_bit() it does not mask tail bits.

Does anybody else really want this?  My gut feel is that this
shouldn't be inline at all (the same is largely true of the existing
ones), and that nobody else really wants this. Nor do we want to
introduce yet another helper function that has very subtly different
semantics that will just confuse people.

So I suspect this should be instead a function that is internal to the
iterator code.

                  Linus
