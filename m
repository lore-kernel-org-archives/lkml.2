Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2ISWSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:18:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36086 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2ISWSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:18:22 -0400
MIME-Version: 1.0
In-Reply-To: <505A3EAB.2030002@att.net>
References: <505A3EAB.2030002@att.net>
Date: Thu, 20 Sep 2012 00:18:21 +0200
Message-ID: <CAFTL4hyF9c5e91JbVxGyo5RSjm3XuvRmhxXLExamZub3ae5KTg@mail.gmail.com>
Subject: Re: Where to put test code?
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/19 Daniel Santos <danielfsantos@att.net>:
> I'm putting the finishing touches on the generic red-black tree test
> code, but I'm uncertain about where to place it exactly.
>
> I haven't finished the test module just yet, but the idea is that the
> tests can be run in userspace as well as kernelspace to make it easier
> to test on multiple compilers.  It has some common sources files (used
> by in both places) and then specific code for both user- and
> kernel-space that I currently have as follows:
>
> tools/testing/selftests/grbtree/       - common.{c,h}
> tools/testing/selftests/grbtree/user   - user-space main.c, Makefile, etc.
> tools/testing/selftests/grbtree/module - kernel-space grbtest.c,
> Makefile, etc.
>
> Would this be correct or should the common & module code go some place
> else and then just have the user-space code under
> tools/testing/selftests/grbtest?

It depends on the nature of your tests. Are these pure validation
tests (some batch
tests that perform actions and check the result is correct) or stress
tests (something
that runs for a while)?

If these are only about validation tests, then both user and module
can be in that
tools/testing/selftests directory.

What is the module doing?
