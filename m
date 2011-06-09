Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1FIP44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:56:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886Ab1FIP4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimAR8ou0dwX_uB8g4pQQtu0+V5k5w@mail.gmail.com>
References: <4DEFD979.50405@tilera.com> <1307607243-5737-1-git-send-email-minipli@googlemail.com>
 <20110609104017.GW11521@ZenIV.linux.org.uk> <BANLkTimAR8ou0dwX_uB8g4pQQtu0+V5k5w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jun 2011 08:56:00 -0700
Message-ID: <BANLkTimVZxa2pvBqzC3RCg+2o_HzHcwtVQ@mail.gmail.com>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
To: Mathias Krause <minipli@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 5:06 AM, Mathias Krause <minipli@googlemail.com> wrote:
>
> ...Albeit by looking closer at the implementation of flush_old_exec()
> I think we should just move the set_fs() call there and remove it from
> the architecture dependent implementations of flush_thread() and
> start_thread().

Yeah, that sounds like the sane (and safe - it won't matter if there
are some architectures that get overlooked and then have a duplicate
set_fs() somewhere) approach.

                              Linus
