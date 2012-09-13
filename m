Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab2IMWql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:46:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64493 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab2IMWqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <50522275.7090709@suse.cz>
References: <50522275.7090709@suse.cz>
Date: Thu, 13 Sep 2012 15:46:30 -0700
Message-ID: <CANN689E0SaT9vaBb+snwYrP728GjZhRj7o7T4GoNfQVY7sBr7Q@mail.gmail.com>
Subject: Re: BUG at mm/huge_memory.c:1428!
From: Michel Lespinasse <walken@google.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:14 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> Hi,
>
> I've just get the following BUG with today's -next. It happens every
> time I try to update packages.
>
> kernel BUG at mm/huge_memory.c:1428!

That is very likely my bug.

Do you have the message that should be printed right above the bug ?
(                printk(KERN_ERR "mapcount %d page_mapcount %d\n",
                       mapcount, page_mapcount(page));
)

Do you get any errors if building with CONFIG_DEBUG_VM and CONFIG_DEBUG_VM_RB ?

Does it go away if you revert "mm: avoid taking rmap locks in
move_ptes()" (cc0eac2e50f036d4d798b18679ca2ae3c4828105 in the -next
version I have here) ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
