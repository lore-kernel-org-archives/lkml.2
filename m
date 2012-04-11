Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546Ab2DKX67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:58:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47806 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761465Ab2DKX65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 16:58:35 -0700
X-Google-Sender-Auth: Lx06JbCjCkviyBnvnPPMbkfxW1Q
Message-ID: <CA+55aFy-CeLXstbceP7+co3AXrEWtifKF+8NWzhC7B-A8xBd-w@mail.gmail.com>
Subject: Re: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h
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
>
> Commit ce1744f4ed20ca8 seems to endorse C users of IS_ENABLED, and
> it went through Linus and Andrew, so I'm not sure scrapping C users
> as a solution will be universally agreeable...

I think we can easily drop IS_ENABLED() if it has been causing
problems. And it clearly is.

And I had never even looked at that generated file. It's disgusting.
We need to stop doing that. It must be driving compile-times up too -
just parsing that monster is RealWork(tm).

                  Linus
