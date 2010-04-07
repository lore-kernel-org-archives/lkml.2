Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0DGPzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:55:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33051 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab0DGPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H0LA8g6W84Px1V77t9OJ+U13mVYCowu7A8FOm1MiVsoUpk8a5sR+P6NcSGYZAw8IcP
         6Jw0TnZ++DnIk0qoNYxcQoq0r7u5ffwiKCB9FT/j1DKDj/b4dRkmKfm8ER+S8TQiyExu
         eH+fyx38IQj3mBPPS70IAViUqSyRUH8gP3v48=
MIME-Version: 1.0
In-Reply-To: <20100407105454.2e7ab9bf@annuminas.surriel.com>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
	 <20100406195459.554265e7@annuminas.surriel.com>
	 <20100407151357.FB7E.A69D9226@jp.fujitsu.com>
	 <20100407105454.2e7ab9bf@annuminas.surriel.com>
Date: Thu, 8 Apr 2010 00:55:28 +0900
Message-ID: <j2s28c262361004070855ib724f594y7c8f01ba8e785bdd@mail.gmail.com>
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas 
	of a mergeable VMA
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.

On Wed, Apr 7, 2010 at 11:54 PM, Rik van Riel <riel@redhat.com> wrote:
> When a new VMA has a mergeable anon_vma with a neighboring VMA,
> make sure all of the neighbor's old anon_vma structs are also
> linked in.
>
> This is necessary because at some point the VMAs could get merged,
> and we want to ensure no anon_vma structs get freed prematurely,
> while the system still has anonymous pages that belong to those
> structs.
>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Rik van Riel <riel@redhat.com>

At last, you might find culprit.

AFAIU your descriptoin, don't we have to care vma_merge case, too?
Sorry if it is dumb question.

-- 
Kind regards,
Minchan Kim
