Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2EKQym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:54:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57187 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2EKQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:54:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqc15HY1rECsJ6Aj1WMzwT12z4DByJhFopyBAiKawEFh3Q@mail.gmail.com>
References: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils>
 <CA+1xoqcChazS=TRt6-7GjJAzQNFLFXmO623rWwjRkdD5x3k=iw@mail.gmail.com>
 <4FACD00D.4060003@kernel.org> <4FACD573.4060103@kernel.org>
 <CA+55aFxsZqU4bXRz61ngnR2ozH=AAhwGHR+PqzdTRfnCxJY0oQ@mail.gmail.com> <CA+1xoqc15HY1rECsJ6Aj1WMzwT12z4DByJhFopyBAiKawEFh3Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2012 09:54:18 -0700
X-Google-Sender-Auth: q_58MuCnT7Ywp3ye2GrpH8gtQnM
Message-ID: <CA+55aFztbcB1sULup-rCsWmOaC7RFLvuJ=sqGQz=SAKzys02mw@mail.gmail.com>
Subject: Re: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction
 to 0
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 9:35 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>
> Once it's on, we reserve 1/x of the pages for the pagelists. I'm not
> sure why 8 was selected in the first place, but I guess it made sense
> that you don't want to reserve 15%+ of your memory for the pagelists.

Why not just accept any number, but turn small numbers into the minimum?

And if it's a per-cpu, then the minimum had better depend on number of
CPU's anyway. 15% of memory on a single-cpu already sounds insanely
high, but if you have several cpu's, it's going to be just totally
crazy.

So a minimum of 8 already sounds broken. Exposing that minimum in a
way that makes it impossible to reset it sounds just insane.

                    Linus
