Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3ACSzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:55:09 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37376 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3ACSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:55:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121222094545.GA4222@google.com>
References: <1356050997-2688-1-git-send-email-walken@google.com>
 <CALCETrUi4JJSahrDKBARrwGsGE=1RbH8WL4tk1YgDmEowzXtSQ@mail.gmail.com>
 <CANN689H+yOeA3pvBMGu52q7brfoDwtkh0pA==c8VVoCkapkx6g@mail.gmail.com>
 <CALCETrU7u7P67QCwmj4qTMHti1=MXyjy3V9FejWbbrMVi01mDw@mail.gmail.com>
 <CANN689GBCsZWKkAQuNGfF4OJwVOyZ5neUcJo=ajzMKNmFug+XQ@mail.gmail.com>
 <CALCETrUOXjm6uoZ=TwyPr0_EQT-10ko5k448FwGP_dMwb=v=AA@mail.gmail.com>
 <CANN689G-+Dns7BEJVG1SNO_CYA1vCEhiyf7F90sKYPvrNsXN9w@mail.gmail.com> <20121222094545.GA4222@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Jan 2013 10:54:44 -0800
Message-ID: <CALCETrU6CAFTUi8t8BzGx6jYe6GuzmUfVyVc=HjWbiY81-MmMQ@mail.gmail.com>
Subject: Re: [PATCH 10/9] mm: make do_mmap_pgoff return populate as a size in
 bytes, not as a bool
To: Michel Lespinasse <walken@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, Jorn_Engel <joern@logfs.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 1:45 AM, Michel Lespinasse <walken@google.com> wrote:
> do_mmap_pgoff() rounds up the desired size to the next PAGE_SIZE multiple,
> however there was no equivalent code in mm_populate(), which caused issues.
>
> This could be fixed by introduced the same rounding in mm_populate(),
> however I think it's preferable to make do_mmap_pgoff() return populate
> as a size rather than as a boolean, so we don't have to duplicate the
> size rounding logic in mm_populate().
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

This appears to fix my hangs.

--Andy
