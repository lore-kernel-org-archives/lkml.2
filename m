Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1CNPZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:25:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33393 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1CNPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kN7qsQeB+fWbHRnQKXmQp7G0sendUbg6RFf6nTuKzOjfBnJeHZRjPquza1VAjtcHBZ
         xDh4CX0hIAoCEW9K1vO+ukaSbQBYprb0BsVML4LrnIJMyjVflkqHbdJkP4dApSfByxLH
         EWn7atJZqxaPUzMwqt7zgdWUJeRA+JdLt288Y=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1103140059510.1661@sister.anvils>
References: <alpine.LSU.2.00.1103140059510.1661@sister.anvils>
Date: Tue, 15 Mar 2011 00:25:32 +0900
Message-ID: <AANLkTimEmv66taMnmNqTHHtoYu4bGAz3BRGbF0ncB40L@mail.gmail.com>
Subject: Re: [PATCH] thp+memcg-numa: fix BUG at include/linux/mm.h:370!
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 5:08 PM, Hugh Dickins <hughd@google.com> wrote:
> THP's collapse_huge_page() has an understandable but ugly difference
> in when its huge page is allocated: inside if NUMA but outside if not.
> It's hardly surprising that the memcg failure path forgot that, freeing
> the page in the non-NUMA case, then hitting a VM_BUG_ON in get_page()
> (or even worse, using the freed page).
>
> Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks, Hugh.
-- 
Kind regards,
Minchan Kim
