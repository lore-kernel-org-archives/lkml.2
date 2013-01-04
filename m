Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3ADAkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:40:12 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35255 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3ADAkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:40:10 -0500
Message-ID: <1357260005.4930.6.camel@kernel.cn.ibm.com>
Subject: Re: [PATCH] mm: protect against concurrent vma expansion
From: Simon Jeons <simon.jeons@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Jan 2013 18:40:05 -0600
In-Reply-To: <CANN689FoSGMUi0mC6dzXe5tXo-BL_4eFZ1NF-De38x8mNhPXcg@mail.gmail.com>
References: <1354344987-28203-1-git-send-email-walken@google.com>
	 <20121203150110.39c204ff.akpm@linux-foundation.org>
	 <CANN689FfWVV4MyTUPKZQgQAWW9Dfdw9f0fqx98kc+USKj9g7TA@mail.gmail.com>
	 <20121203164322.b967d461.akpm@linux-foundation.org>
	 <20121204144820.GA13916@google.com>
	 <1355968594.1415.4.camel@kernel-VirtualBox>
	 <CANN689FoSGMUi0mC6dzXe5tXo-BL_4eFZ1NF-De38x8mNhPXcg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 19:01 -0800, Michel Lespinasse wrote:
> Hi Simon,
> 
> On Wed, Dec 19, 2012 at 5:56 PM, Simon Jeons <simon.jeons@gmail.com> wrote:
> > One question.
> >
> > I found that mainly callsite of expand_stack() is #PF, but it holds
> > mmap_sem each time before call expand_stack(), how can hold a *shared*
> > mmap_sem happen?
> 
> the #PF handler calls down_read(&mm->mmap_sem) before calling expand_stack.
> 
> I think I'm just confusing you with my terminology; shared lock ==
> read lock == several readers might hold it at once (I'd say they share
> it)

Sorry for my late response. 

Since expand_stack() will modify vma, then why hold a read lock here?

> 


