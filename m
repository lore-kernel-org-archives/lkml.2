Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2EZTwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 15:52:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65371 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2EZTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 15:52:17 -0400
MIME-Version: 1.0
In-Reply-To: <1337782454.20792.63.camel@lappy>
References: <1337782454.20792.63.camel@lappy>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 26 May 2012 21:51:56 +0200
Message-ID: <CA+1xoqc2DoswwM737QkkdeY0gqoqFor4RSnThTqMiVT8YDK-mQ@mail.gmail.com>
Subject: Re: GPF in numa_vma_unlink
To: a.p.zijlstra@chello.nl, mingo@kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 4:14 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Hi all,
>
> During fuzzing with trinity inside a KVM tools guest, using latest linux-next, I've stumbled on the following:

So it can be fixed by getting the 'ng_put(ng)' to go under ng lock,
but since the locking (and the locking related comments) in
kernel/sched/numa.c look very confusing, I'm not sure if that's the
right solution.
