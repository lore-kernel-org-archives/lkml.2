Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2G1Cbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 22:31:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33403 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2G1Cbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 22:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689Fn=DYR8eGKkBJPeQYMtOfP6tykzqLMBOdV0Yg8OdrVPQ@mail.gmail.com>
References: <1342787467-5493-1-git-send-email-walken@google.com>
	<1342787467-5493-6-git-send-email-walken@google.com>
	<1343419375.32120.48.camel@twins>
	<CANN689Fn=DYR8eGKkBJPeQYMtOfP6tykzqLMBOdV0Yg8OdrVPQ@mail.gmail.com>
Date: Fri, 27 Jul 2012 19:31:42 -0700
Message-ID: <CANN689Hh3djSxU8F7GK1An1jEZTDhG+Yo4VSFcE6UxvOHrhVag@mail.gmail.com>
Subject: Re: [PATCH 5/6] rbtree: faster augmented erase
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 5:44 PM, Michel Lespinasse <walken@google.com> wrote:
> On Fri, Jul 27, 2012 at 1:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> As it stands rb_erase() isn't inlined and its rather big,
>> why would you want to inline it for augmented callers?
>
> Just as the non-augmented rb_erase() is generated (as a non-inline
> function) by merging together the rb_erase_augmented() inline function
> and its dummy callbacks, I want each library that uses augmented
> rbtrees to generate their own rb_erase() equivalent using their own
> callbacks. The inline function in rbtree_internal.h is only to be used
> as a template for generating one non-inline instance for each data
> structure that uses augmented rbtrees.

One more thing while we're talking about compiled code size. As you
noted, the non-augmented rb_erase() is pretty big. However, that size
includes the inlined rebalancing code. For the augmented erase
functions, my proposal is to the rebalancing part (rb_erase_color with
the rotate callback) will not be inlined, so as to limit the size of
the erase functions for each augmented rbtree data structure.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
