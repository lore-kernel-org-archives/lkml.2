Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2FAJMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:12:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34662 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab2FAJMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:12:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1206010204150.8697@eggly.anvils>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
 <4FC88299.1040707@gmail.com> <alpine.LSU.2.00.1206010204150.8697@eggly.anvils>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 1 Jun 2012 05:12:19 -0400
Message-ID: <CAHGf_=q-VBqtABfC7cYPFY6AtQjjwHAM+0BD-DQ2G1sYoTPKGA@mail.gmail.com>
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 5:08 AM, Hugh Dickins <hughd@google.com> wrote:
> On Fri, 1 Jun 2012, KOSAKI Motohiro wrote:
>> >     mlock_migrate_page(newpage, page);
>> > --- 3.4.0+/mm/page-writeback.c      2012-05-29 08:09:58.304806782 -0700
>> > +++ linux/mm/page-writeback.c       2012-06-01 00:23:43.984116973 -0700
>> > @@ -1987,7 +1987,10 @@ int __set_page_dirty_nobuffers(struct pa
>> >             mapping2 = page_mapping(page);
>> >             if (mapping2) { /* Race with truncate? */
>> >                     BUG_ON(mapping2 != mapping);
>> > -                   WARN_ON_ONCE(!PagePrivate(page)&&
>> > !PageUptodate(page));
>> > +                   if (WARN_ON(!PagePrivate(page)&&
>> > !PageUptodate(page)))
>> > +                           print_symbol(KERN_WARNING
>> > +                               "mapping->a_ops->writepage: %s\n",
>> > +                               (unsigned
>> > long)mapping->a_ops->writepage);
>>
>> type mismatch?
>
> I don't think so: I just copied from print_bad_pte().
> Probably you're reading "printk" where it's "print_symbol"?

Oops, yes, sorry for noise.


>> I guess you want %pf or %pF.
>
> I expect there is new-fangled %pMagic that can do it too, yes.
