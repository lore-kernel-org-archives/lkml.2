Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab2FHB0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:26:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59021 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762Ab2FHB0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120608011215.GB7191@redhat.com>
References: <20120608002451.GA821@redhat.com> <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
 <20120608010008.GA7191@redhat.com> <CA+55aFxwVWiVwxj39DoJmMTknh7JKvCxzxyu-cMQZwd53jOmgQ@mail.gmail.com>
 <20120608011215.GB7191@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 18:25:45 -0700
X-Google-Sender-Auth: rMTPx5BpdoEWi8aVj_GwMOxxPqo
Message-ID: <CA+55aFyxN8vQo7UXwJ0V1jZyE137aX2ZwtXVvGhNFTz4NjxvDg@mail.gmail.com>
Subject: Re: a whole bunch of crashes since todays -mm merge.
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 6:12 PM, Dave Jones <davej@redhat.com> wrote:
>
> I don't think so ? I have CONFIG_SPLIT_PTLOCK_CPUS=999999,
> so it looks like that never gets defined unless I'm missing something obvious.

Yeah, I think you're right. And in that case I don't think the
sync_mm_rss() patch should matter. Although it does move mm_release()
around, which makes me nervous - that could cause independent issues.
I never got that far in analyzing the patch, because I got hung up on
the obvious problems and decided to revert it as obviously broken and
untested.

Btw, I really wish we didn't do that complicated USE_SPLIT_PTLOCKS ->
SPLIT_RSS_COUNTING stuff hidden in the header files. I suspect we
should do it in the mm/Kconfig file instead, and make them normal
config options. I think that makes it easier to grep for.

              Linus
