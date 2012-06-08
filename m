Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab2FHAxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:53:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab2FHAxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120608002451.GA821@redhat.com>
References: <20120608002451.GA821@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 17:52:52 -0700
X-Google-Sender-Auth: zn_SaMqPVT1_RLu9ObWleIp5s2o
Message-ID: <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
Subject: Re: a whole bunch of crashes since todays -mm merge.
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 5:24 PM, Dave Jones <davej@redhat.com> wrote:
> I just started seeing crashes while doing simple things, like logging on a console..

I'm looking at it right now, and the sync_mm_rss() patch is pure
garbage. In many ways.

You can't do sync_mm_rss() from mmdrop(), because there's no reason to
believe that the task that does mmdrop() does it on its own active_mm.
And even if you *could* do it there, it's still horribly wrong,
because it does it at the end *after* it already freed the mm!

Does it go away if you revert that (commit 40af1bbdca47). I wish I
hadn't merged it, or that I had noticed how horrible it was before I
pushed out.

              Linus
