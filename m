Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab2DLAFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:05:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63662 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933676Ab2DLAFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <1334188257-3449-6-git-send-email-paul.gortmaker@windriver.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com> <1334188257-3449-6-git-send-email-paul.gortmaker@windriver.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 17:04:45 -0700
X-Google-Sender-Auth: woCwlFzcZ4VjMO6911gs10lp7x0
Message-ID: <CA+55aFxmpotS+Yw0niuYRq4eqpYjx6=TAvoz8v=NxD3N_7u7qg@mail.gmail.com>
Subject: Re: [PATCH 5/5] kconfig: limit IS_ENABLED & similar to CPP usage
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 4:50 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> Using IS_ENABLED() within C (vs. within CPP #if statements) requires
> us to actually define every possible bool/tristate Kconfig option
> twice (__enabled_* and __enabled_*_MODULE variants).

Why do you keep the __enabled_*[_MODULE] things alive at all?

Why can't you just check the CONFIG_xyz[_MODULE] #defines directly?

IOW, why isn't IS_ENABLED() just

  #define IS_ENABLED(option) \
    (defined(CONFIG_##option) || defined(CONFIG_##option##_MODULE))

  #define IS_BUILTIN(option) \
    (defined(CONFIG_##option))

and we're done with it all? What's the advantage of the __enabled_
thing again, when you depend on the preprocessor anyway?

                      Linus
