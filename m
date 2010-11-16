Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307Ab0KPLuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:50:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:33532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933866Ab0KPLux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:50:53 -0500
Subject: Re: [PATCH -v4 2/2] lib, Add lock-less NULL terminated single list
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1289868791-16658-3-git-send-email-ying.huang@intel.com>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	 <1289868791-16658-3-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 12:50:41 +0100
Message-ID: <1289908241.2109.570.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 08:53 +0800, Huang Ying wrote:
> +/**
> + * llist_del_all - delete all entries from lock-less list
> + * @head:      the head of lock-less list to delete all entries
> + *
> + * If list is empty, return NULL, otherwise, delete all entries and
> + * return the pointer to the first entry.
> + */
> +struct llist_node *llist_del_all(struct llist_head *head)
> +{
> +       return xchg(&head->first, NULL);
> +}
> +EXPORT_SYMBOL_GPL(llist_del_all); 

Its not del_all, since it returns the actual list. move or splice might
be better names.
