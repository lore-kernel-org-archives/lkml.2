Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1BHS3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:29:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20214 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab1BHS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CoK7FADPLk2wR7Y6xGhdxnM29fGbvP9BXu+zr6DoKH9BticjcDjLuUNRCTgwiPqYJ8
         t/ZqrLmx3s7x5gbIWM+A==
MIME-Version: 1.0
In-Reply-To: <1297126056-14322-3-git-send-email-walken@google.com>
References: <1297126056-14322-1-git-send-email-walken@google.com>
	<1297126056-14322-3-git-send-email-walken@google.com>
Date: Tue, 8 Feb 2011 10:29:16 -0800
Message-ID: <AANLkTimXQJxFHC_NcBJkutiv9N_57DDHBUGawdKrt2xH@mail.gmail.com>
Subject: Re: [PATCH 2/2] mlock: do not munlock pages in __do_fault()
From: Hugh Dickins <hughd@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 4:47 PM, Michel Lespinasse <walken@google.com> wrote:
> If the page is going to be written to, __do_page needs to break COW.
> However, the old page (before breaking COW) was never mapped mapped into
> the current pte (__do_fault is only called when the pte is not present),
> so vmscan can't have marked the old page as PageMlocked due to being
> mapped in __do_fault's VMA. Therefore, __do_fault() does not need to worry
> about clearing PageMlocked() on the old page.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Hugh Dickins <hughd@google.com>
