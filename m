Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140Ab2DLBzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:55:35 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40080 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab2DLBzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120411184538.ec21844a.akpm@linux-foundation.org>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
 <CA+55aFy-CeLXstbceP7+co3AXrEWtifKF+8NWzhC7B-A8xBd-w@mail.gmail.com>
 <CA+55aFx6V_TpbghsG7xqoBree8ALAKWMA+qLeGg-8DNAno+peg@mail.gmail.com> <20120411184538.ec21844a.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 18:55:10 -0700
X-Google-Sender-Auth: Ju8JbKu4_yW5pvgR2H6boTDjVyo
Message-ID: <CA+55aFx9WXtF7LT9rHv0=e0jqAq+b1cDPcRzSGDKvy7+XjxxtA@mail.gmail.com>
Subject: Re: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, tony@bakeyournoodle.com, mmarek@suse.cz,
        lacombar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 6:45 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> So we shouldn't call it IS_DEFINED() - that would cause confusion with
> the old version.

Yeah. Maybe we should call it "config_enabled()" - the lower-case
hopefully makes it clear that it acts as a C function, not a
preprocessor one.

Code like "if (config_enabled(IPV6))" looks reasonably readable to me.

I asked G+ if they can come up with a better trick. They did well on
the whole bitmask calculations, maybe somebody can figure out how to
make the same macro work for both preprocessor and C code...

                       Linus
