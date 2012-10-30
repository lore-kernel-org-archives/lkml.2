Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2J3Pfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:35:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49178 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2J3Pfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:35:40 -0400
MIME-Version: 1.0
In-Reply-To: <1351609517.8467.85.camel@gandalf.local.home>
References: <CAFbHwiRtBaHkpZqTm6VZ=fCJcyu+dsdpo_kxMHy1egce=rTuyA@mail.gmail.com>
	<1351609517.8467.85.camel@gandalf.local.home>
Date: Tue, 30 Oct 2012 15:35:38 +0000
Message-ID: <CAFbHwiRXzWpKjtu2jQzr_COuSLg=HNit-CfkTuArrzc+xP53Og@mail.gmail.com>
Subject: Re: [PATCH] scripts/recordmcount.pl: Support build with -ffunction-sections.
From: Will Newton <will.newton@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 3:05 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-10-30 at 14:51 +0000, Will Newton wrote:
>> Scan any text section whose name begins with ".text." so
>> we will find all the functions in a kernel built with
>> -ffunction-sections.
>
> A couple of things.
>
> First, I'm very paranoid about a blanket "ok" on sections. We must
> guarantee that all sections that starts with ".text" never is freed. And
> if it is freed, that it must inform ftrace that it's about to free it
> before it does. If we can not guarantee this, then we can't do it.

I share that concern, however it looks like it should be safe. The two
architectures in tree that enable -ffunction-sections by default are
parisc and score and they both use a .text.* wildcard in their linker
script. If the support for building with --gc-sections is ever
completed then that would require -ffunction-sections and a similar
wildcard to be applied to section names.

> Second, most archs today do not use recordmcount.pl. They use the new
> recordmcount.c file.

Ok, thanks for letting me know. Is the plan to switch over to
recordmcount.c exclusively at some point?

The following architectures have some support in recordmcount.c but do
not enable it:

sh, powerpc, ia64

And the following have no support in recordmcount.c as yet:

blackfin, microblaze
