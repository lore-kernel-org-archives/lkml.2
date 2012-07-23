Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2GWTJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:09:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42859 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2GWTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:09:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120723190422.GA2703@fieldses.org>
References: <20120713173536.GB25432@redhat.com> <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
 <20120723152038.GB623@fieldses.org> <CA+55aFxGuoxbdxy3uKX063vZ1xSRhshRyWf_UhMnDL_by7j9Sg@mail.gmail.com>
 <20120723190422.GA2703@fieldses.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2012 12:09:21 -0700
X-Google-Sender-Auth: h4sYz_BXYLly8W_kcYjlfbVjusg
Message-ID: <CA+55aFwteHEnWm9ejmPoWZXTqjum1pC9fM6sKV_mRHGo2oorpA@mail.gmail.com>
Subject: Re: Remove easily user-triggerable BUG from generic_setlease
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 12:04 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>
> Right, I wasn't clear: that patch should go to mainline as well.

Does it do anything in mainline?

> (Then, do we still want Dave's patch?: in some sense that BUG() was
> correct

Hell no.

A BUG() is *never* correct unless it's a situation where not having
the bug would do something worse (ie subtly corrupt memory). And quite
frankly, if you had a BUG() there and knew about the memory
corruption, that's just a f*cking disgrace. So no, no excuse for
BUG()s like that.

NEVER EVER add BUG() as a "well, that was unexpected". That way lies
exactly the kinds of denial-of-service attacks that that BUG() caused.

The only valid source of BUG() is if you actually find internal data
structure *corruption*, and you say "ok, I cannot possibly continue,
because anything I would do would be wrong".

Seriously. People who use BUG() statements like some kind of assert()
are a menace to society. They kill machines.

                Linus
