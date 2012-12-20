Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2LTDH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 22:07:28 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:42516 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2LTDHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 22:07:22 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 22:07:22 EST
MIME-Version: 1.0
In-Reply-To: <1355968594.1415.4.camel@kernel-VirtualBox>
References: <1354344987-28203-1-git-send-email-walken@google.com>
	<20121203150110.39c204ff.akpm@linux-foundation.org>
	<CANN689FfWVV4MyTUPKZQgQAWW9Dfdw9f0fqx98kc+USKj9g7TA@mail.gmail.com>
	<20121203164322.b967d461.akpm@linux-foundation.org>
	<20121204144820.GA13916@google.com>
	<1355968594.1415.4.camel@kernel-VirtualBox>
Date: Wed, 19 Dec 2012 19:01:30 -0800
Message-ID: <CANN689FoSGMUi0mC6dzXe5tXo-BL_4eFZ1NF-De38x8mNhPXcg@mail.gmail.com>
Subject: Re: [PATCH] mm: protect against concurrent vma expansion
From: Michel Lespinasse <walken@google.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Wed, Dec 19, 2012 at 5:56 PM, Simon Jeons <simon.jeons@gmail.com> wrote:
> One question.
>
> I found that mainly callsite of expand_stack() is #PF, but it holds
> mmap_sem each time before call expand_stack(), how can hold a *shared*
> mmap_sem happen?

the #PF handler calls down_read(&mm->mmap_sem) before calling expand_stack.

I think I'm just confusing you with my terminology; shared lock ==
read lock == several readers might hold it at once (I'd say they share
it)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
