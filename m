Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab2CGC1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:27:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53216 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2CGC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:27:53 -0500
MIME-Version: 1.0
In-Reply-To: <4F56AC21.1050000@gmail.com>
References: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com> <4F56AC21.1050000@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2012 18:27:32 -0800
X-Google-Sender-Auth: Hbwn8QlYnaQJ4X-POPVjPA7S4eI
Message-ID: <CA+55aFwdV1UmsmC+PMMEDmq-TyqGWORdYVfGq4AdZ6+iO2eQ6Q@mail.gmail.com>
Subject: Re: [PATCH] fix bug introduced in "mm: simplify find_vma_prev()"
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 4:30 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> I prefer to remove find_vma_prev() eventually. but this is good short term
> solution.

Ok, applied.

And then I committed an extra patch that removed the really obvious
cases of find_vma_prev() (ie where it immediately returns if the
resulting "vma" is NULL.

There may well be a few more cases that really only need find_vma(),
but if it wasn't totally obvious from the grep output with just a
couple of lines of context, I left it alone for now.

                Linus
