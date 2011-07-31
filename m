Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1GaXUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:20:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65373 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1GaXU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <1312151687.18010.31.camel@i7.infradead.org>
References: <1312141497-13854-1-git-send-email-lacombar@gmail.com>
	<1312143643.12369.32.camel@i7.infradead.org>
	<CACqU3MXak0Yo+VDQNEqT9rTJ5CjdU6jJ-C1Km7GauMQ+qGW+vg@mail.gmail.com>
	<1312151687.18010.31.camel@i7.infradead.org>
Date: Sun, 31 Jul 2011 19:20:26 -0400
Message-ID: <CACqU3MUfnt9Pn1Sen-Q=6W-n904Qu842Goo3n4iq_uyK0fQ3rg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: honor the ARCH setting of the existing configuration
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 6:34 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>> I am working with configuration for mips, sh, powerpc, arm and x86.
>> Some of them are for real board, some of them are to regress-test
>> compilers, binutils and kernel builds. Each of those config hardcode
>> the CROSS_COMPILER string and have their own build directory. In each
>> case, I want to be able to just run "make O=/src/obj/v3.0-arm
>> oldnoconfig all" without having to worry about anything else.
>
> Yes, that's a valid but *separate* problem.
yes, but I never really looked at it so far, I had the occasion now,
and did the patch.

> FWIW I usually solve this problem with a two-line GNUmakefile:
>        ARCH := arm
>        include Makefile
>
this would not work as I might ends up being multiple build in
parallel and I am an aficionados of `git clean -fdx' so the extra file
would go away.

> I haven't checked whether it works for out-of-source-tree builds; I bet
> it could be made to.
>
> I would love to see $ARCH turned into a proper configuration option.
>
I do not think this would be that hard, the main issue is that it
would heavily be cross-tree.

 - Arnaud
