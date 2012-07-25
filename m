Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2GYRzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab2GYRzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:55:23 -0400
Message-ID: <501032A3.3010705@redhat.com>
Date: Wed, 25 Jul 2012 13:53:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] rbtree: faster augmented erase
References: <1342787467-5493-1-git-send-email-walken@google.com> <1342787467-5493-6-git-send-email-walken@google.com> <20120724015410.GA9690@google.com>
In-Reply-To: <20120724015410.GA9690@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 09:54 PM, Michel Lespinasse wrote:
> Add an augmented tree rotation callback to __rb_erase_color(), so that
> augmented tree information can be maintained while rebalancing.
>
> Also introduce rb_erase_augmented(), which is a version of rb_erase()
> with augmented tree callbacks. We need three callbacks here: one to
> copy the subtree's augmented value after stitching in a new node as
> the subtree root (rb_erase_augmented cases 2 and 3), one to propagate
> the augmented values up after removing a node, and one to pass up to
> __rb_erase_color() to handle rebalancing.
>
> Things are set up so that rb_erase() uses dummy do-nothing callbacks,
> which get inlined and eliminated by the compiler, and also inlines the
> __rb_erase_color() call so as to generate similar code than before
> (once again, the compiler somehow generates smaller code than before
> with all that inlining, but the speed seems to be on par). For the
> augmented version rb_erase_augmented(), however, we use partial
> inlining: we want rb_erase_augmented() and its augmented copy and
> propagation callbacks to get inlined together, but we still call into
> a generic __rb_erase_color() (passing a non-inlined callback function)
> for the rebalancing work. This is intended to strike a reasonable
> compromise between speed and compiled code size.

I guess moving the inlined function to the include file
takes care of my concerns for patch 4/6...

> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>
