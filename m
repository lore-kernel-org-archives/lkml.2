Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab1CBSBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:01:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077Ab1CBSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:01:14 -0500
MIME-Version: 1.0
In-Reply-To: <20110302164428.GF26810@redhat.com>
References: <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com>
 <20110225175314.GD19059@redhat.com> <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com>
 <20110226123731.GC4416@redhat.com> <AANLkTinFVCR_znYtyVuJcjFQq_fgMp+ozbSz54UKzvQ_@mail.gmail.com>
 <20110226174408.GA17442@redhat.com> <20110301204739.GA30406@redhat.com>
 <AANLkTikVecxcGoZ9a4hmkoi4wynrNfH9_AU7Vb+hOvbH@mail.gmail.com>
 <20110302162650.GA26810@redhat.com> <20110302164428.GF26810@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Mar 2011 10:00:23 -0800
Message-ID: <AANLkTinzQmprg+XHKjTj7bA+jFf_N4hta3_09M+SEfRt@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] exec: unify native/compat code
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 8:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> forgot to mention...
>
> And probably you meant we should pass "struct conditional_ptr*", not
> by value. I can redo again.

No, I think we're ok with passing the structure by value - it's a
small structure that would generally be passed in registers (at least
on some architectures, I guess it will depend on the ABI), and we do
the "struct-by-value" thing for other things too (notably the page
table entries), so it's not a new thing in the kernel.

So I think I finally have no complaints. Of course, I didn't actually
check whether it _works_, but I assume it does.

If the s390 people (who actually do special things with compat
pointers) can test, that would be ok, but I'm certainly happily going
to apply this series when the next merge window opens.

                            Linus
