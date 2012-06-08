Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab2FHBUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:20:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59594 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759714Ab2FHBUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1206071759050.1291@eggly.anvils>
References: <20120607212114.E4F5AA02F8@akpm.mtv.corp.google.com>
 <CA+55aFxOWR_h1vqRLAd_h5_woXjFBLyBHP--P8F7WsYrciXdmA@mail.gmail.com>
 <CA+55aFyQUBXhjVLJH6Fhz9xnpfXZ=9Mej5ujt6ss7VUqT1g9Jg@mail.gmail.com> <alpine.LSU.2.00.1206071759050.1291@eggly.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 18:19:57 -0700
X-Google-Sender-Auth: zxwf0dJNOZj_bfxbwyu9hlcX1U8
Message-ID: <CA+55aFw7y5FBJm6pxiHHsoiPaVQG3A+4u6J9=4DGd8kVPjmzGQ@mail.gmail.com>
Subject: Re: [patch 12/12] mm: correctly synchronize rss-counters at exit/exec
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, khlebnikov@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de,
        oleg@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, this is apparently that same "almost there" patch from Oleg. I
guarantee that it's wrong.

                Linus

---

[ This part, to be exact: ]

On Thu, Jun 7, 2012 at 6:16 PM, Hugh Dickins <hughd@google.com> wrote:
> --- a/kernel/tsacct.c
> +++ b/kernel/tsacct.c
> @@ -91,6 +91,7 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
>        stats->virtmem = p->acct_vm_mem1 * PAGE_SIZE / MB;
>        mm = get_task_mm(p);
>        if (mm) {
> +               sync_mm_rss(mm);
>                /* adjust to KB unit */
>                stats->hiwater_rss   = get_mm_hiwater_rss(mm) * PAGE_SIZE / KB;
>                stats->hiwater_vm    = get_mm_hiwater_vm(mm)  * PAGE_SIZE / KB;
> --
> 1.5.5.1
