Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2GCAXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:23:13 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49562 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2GCAXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120630013318.GB27797@google.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	<1340315835-28571-6-git-send-email-riel@surriel.com>
	<20120630013318.GB27797@google.com>
Date: Mon, 2 Jul 2012 17:23:10 -0700
Message-ID: <CANN689HTeEKGU=tdm-bfsCT5yttL7qGL827zV1XfEe007UE18A@mail.gmail.com>
Subject: Re: [PATCH -mm v2 05/11] mm: get unmapped area from VMA tree
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        andi@firstfloor.org, hannes@cmpxchg.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 6:33 PM, Michel Lespinasse <walken@google.com> wrote:
>                 if (!found_here) {      // or if(!addr) or whatever
>                         struct rb_node *rb_prev = NULL;
>                         do {
>                                 if (rb_node != rb_prev &&

Gah, that last line was meant to be if (rb_node->rb_right != rb_prev &&

>                                     node_free_gap(rb_node->rb_right) >= len) {
>                                         rb_node = rb_node->rb_right;
>                                         break;
>                                 }
>                                 rb_prev = rb_node;
>                                 rb_node = rb_parent(rb_node);
>                         } while (rb_node);
>                         continue;
>                 }

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
