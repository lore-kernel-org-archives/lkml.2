Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab2HFUqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:46:15 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42022 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab2HFUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:46:14 -0400
MIME-Version: 1.0
In-Reply-To: <1344263015.27828.58.camel@twins>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	<1343946858-8170-3-git-send-email-walken@google.com>
	<1344263015.27828.58.camel@twins>
Date: Mon, 6 Aug 2012 13:46:12 -0700
Message-ID: <CANN689EHcas5zFyNeDzpapO_ddQiMjbfSwPvjcYQM8ce-Z_zVQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] rbtree: optimize fetching of sibling node
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 7:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
>
>> +             tmp = gparent->rb_right;
>> +             if (parent != tmp) {    /* parent == gparent->rb_left */
>
>> +                     tmp = parent->rb_right;
>> +                     if (node == tmp) {
>
>> +                     tmp = parent->rb_left;
>> +                     if (node == tmp) {
>
>> +             sibling = parent->rb_right;
>> +             if (node != sibling) {  /* node == parent->rb_left */
>
> Half of them got a comment, the other half didn't.. is there any
> particular reason for that?

I felt that the equality tests didn't need explanation. But the tests
where I test for inequality with the supposed sibling didn't seem
quite so obvious to me, so I commented them.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
