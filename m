Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1JVHaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:30:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59593 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1JVHaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAAiDW_RfbuWt6C3ixe1gM5FLTJZ7ekpGsaSMgVnt+bSy1mBUBg@mail.gmail.com>
References: <CAAiDW_RfbuWt6C3ixe1gM5FLTJZ7ekpGsaSMgVnt+bSy1mBUBg@mail.gmail.com>
Date: Sat, 22 Oct 2011 13:30:12 +0600
Message-ID: <CADZ9YHjbW5Wi0r68+DmXC2_M6BAwV1yzeBqPsEtEH8VQh1wLUQ@mail.gmail.com>
Subject: Re: Page Faults
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Artur Baruchi <mail.baruchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 8:12 AM, Artur Baruchi <mail.baruchi@gmail.com> wrote:
> Hi Guys.
>
> I would like to create a module (probably unsig kprobe or jproble) to
> separate some kinds of page faults. For example, suppose that during
> 10min my system experienced a total of 100 page faults. This module
> should show me that, 10 page faults happened in cache, 30 page faults
> happened in kernel pages, and so on...
> My question is... which function should I probe to accomplish this?
>
Maybe you're looking for arch/x86/mm/fault.c:do_page_fault(). But,
do_page_fault is tagged with __kprobes, so maybe you can't use this
function with kprobe. You need to find some other solutions. perf
tools has an option for page fault counting, see whether it satisfies
your need. Use 'perf list' to see all the events.

Thanks,
Rakib
