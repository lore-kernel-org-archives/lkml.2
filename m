Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1JAWmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:42:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62755 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1JAWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
	<CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
Date: Sun, 2 Oct 2011 00:41:59 +0200
Message-ID: <CAA879TPzmVh4yR5n4Mfd8D6ERpvAFipeMXr1QBr3fwQMdvnRzw@mail.gmail.com>
Subject: Re: taskstats root only breaking iotop
From: Guillaume Chazarain <guichaz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 11:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I think the question should be: why is it *ever* a good idea to let
> *anybody* read how many bytes anybody has read.

I use iotop to get the throughput of a cp or tar because I don't
always think of piping to 'pv'. People also use it as a progress
indicator for their less verbose applications (total bytes
read/written instead of rate).

I see on forums people use it to find which process is hammering their
disk, though in this case the time spent on I/Os is more useful than
the throughput and this is not broken by these changes assuming they
have root.

> If you want that kind of detail, do "strace". Don't do that abortion
> that is taskstats.

strace is not always appropriate: it's invasive as it slows down the
traced process and it's not aggregating anything.

> Right now, TASKSTATS is a total and utter disaster.

I'm not attached to taskstats, I'd be happy to migrate to what comes next.

> and it's a crazy idea to
> begin with.

But it's not clear to me if you dislike just the taskstats
implementation or the general idea of precise per task I/O stats.

Thanks for taking the time to explain your reasoning, I'm not trying
to resurrect taskstats, just checking if I should expect a brighter
future for iotop.

-- 
Guillaume
