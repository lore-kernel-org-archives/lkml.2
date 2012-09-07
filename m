Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab2IGW3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:29:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44503 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2IGW3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120907151341.79cb5638.akpm@linux-foundation.org>
References: <1346750457-12385-1-git-send-email-walken@google.com>
	<1346750457-12385-2-git-send-email-walken@google.com>
	<20120907151341.79cb5638.akpm@linux-foundation.org>
Date: Fri, 7 Sep 2012 15:29:36 -0700
Message-ID: <CANN689HMxteeUT9q5BgKutEnNQF6sKv2n9ze11Z=wkOoC+XGqw@mail.gmail.com>
Subject: Re: [PATCH 1/7] mm: interval tree updates
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, riel@redhat.com, peterz@infradead.org,
        aarcange@redhat.com, hughd@google.com, daniel.santos@pobox.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 3:13 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue,  4 Sep 2012 02:20:51 -0700
> Michel Lespinasse <walken@google.com> wrote:
>
>> This commit updates the generic interval tree code that was
>> introduced in "mm: replace vma prio_tree with an interval tree".
>>
>> Changes:
>>
>> - fixed 'endpoing' typo noticed by Andrew Morton
>>
>> - replaced include/linux/interval_tree_tmpl.h, which was used as a
>>   template (including it automatically defined the interval tree
>>   functions) with include/linux/interval_tree_generic.h, which only
>>   defines a preprocessor macro INTERVAL_TREE_DEFINE(), which itself
>>   defines the interval tree functions when invoked. Now that is a very
>>   long macro which is unfortunate, but it does make the usage sites
>>   (lib/interval_tree.c and mm/interval_tree.c) a bit nicer than previously.
>>
>> - make use of RB_DECLARE_CALLBACKS() in the INTERVAL_TREE_DEFINE() macro,
>>   instead of duplicating that code in the interval tree template.
>>
>> - replaced vma_interval_tree_add(), which was actually handling the
>>   nonlinear and interval tree cases, with vma_interval_tree_insert_after()
>>   which handles only the interval tree case and has an API that is more
>>   consistent with the other interval tree handling functions.
>>   The nonlinear case is now handled explicitly in kernel/fork.c dup_mmap().
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>> ---
>>  include/linux/interval_tree_generic.h |  191 ++++++++++++++++++++++++++++
>>  include/linux/interval_tree_tmpl.h    |  219 ---------------------------------
>
> Well that's a mess.  We create interval_tree_generic.h then four
> commits later it vanishes, never to return.  And I can't fold
> mm-interval-tree-updates.patch into
> mm-replace-vma-prio_tree-with-an-interval-tree.patch because
> rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
> mucks with interval_tree_generic.h within those four commits.
>
> Ho hum.  I don't think I can be bothered untangling all this.

I don't think you should have to do it yourself either.

But, if you're willing to take it, I can send you replacement patches for
(mm-replace-vma-prio_tree-with-an-interval-tree.patch +
mm-interval-tree-updates.patch) collapsed into one, and
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
fixed so that it'd apply after the collapsed patch (and get to the
same end state).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
