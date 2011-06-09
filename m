Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1FIREF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:04:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab1FIRED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <D167BDC0-BB1A-41B8-A59D-DD60FFA027CE@googlemail.com>
References: <4DEFD979.50405@tilera.com> <1307607243-5737-1-git-send-email-minipli@googlemail.com>
 <20110609104017.GW11521@ZenIV.linux.org.uk> <BANLkTimAR8ou0dwX_uB8g4pQQtu0+V5k5w@mail.gmail.com>
 <BANLkTimVZxa2pvBqzC3RCg+2o_HzHcwtVQ@mail.gmail.com> <D167BDC0-BB1A-41B8-A59D-DD60FFA027CE@googlemail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jun 2011 10:03:06 -0700
Message-ID: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
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

On Thu, Jun 9, 2011 at 9:40 AM, Mathias Krause <minipli@googlemail.com> wrote:
>
> So the only question left: Should it be one patch moving the set_fs() call to
> flush_old_exec() and also removing the redundant calls in flush_thread() and
> start_thread() or should that be split into one for the set_fs() move and
> multiple ones for the arch specific set_fs() remove?

I'd suggest one patch that moves the set_fs(), and then possibly
removes the ones from architectures that who-ever wrote the patch can
actively test.

Doing random other architectures is not worth the effort or confusion, imho.

                            Linus
