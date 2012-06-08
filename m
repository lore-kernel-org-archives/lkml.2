Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab2FHBGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:06:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61700 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab2FHBGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:06:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120608010008.GA7191@redhat.com>
References: <20120608002451.GA821@redhat.com> <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
 <20120608010008.GA7191@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 18:06:27 -0700
X-Google-Sender-Auth: zMIcz8e_tsTNrsx3rYFP1ubgErg
Message-ID: <CA+55aFxwVWiVwxj39DoJmMTknh7JKvCxzxyu-cMQZwd53jOmgQ@mail.gmail.com>
Subject: Re: a whole bunch of crashes since todays -mm merge.
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 6:00 PM, Dave Jones <davej@redhat.com> wrote:
>
> Or I might just be getting lucky..

Do you have SPLIT_RSS_COUNTING enabled?

Do you see multiple "BUG: Bad rss-counter state" messages?

The sync_mm_rss() thing could basically overwrite an already-free'd
piece of memory, so it could cause pretty random stuff. But I think
you need to be unlucky to hit the window.

                Linus
