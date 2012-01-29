Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2A2MYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 07:24:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50523 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab2A2MYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 07:24:17 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <1327572121-13673-2-git-send-email-gilad@benyossef.com>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327572121-13673-2-git-send-email-gilad@benyossef.com>
Date: Sun, 29 Jan 2012 14:24:16 +0200
Message-ID: <CAOtvUMc3XJ_SqpWAZnhyi6Anjd6rEGQTK_iAWJox-5Y4n4Z8hQ@mail.gmail.com>
Subject: Re: [v7 1/8] smp: introduce a generic on_each_cpu_mask function
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 12:01 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> on_each_cpu_mask calls a function on processors specified by
> cpumask, which may or may not include the local processor.
>
> You must not call this function with disabled interrupts or
> from a hardware interrupt handler or from a bottom half handler.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reviewed-by: Christoph Lameter <cl@linux.com>
> CC: Chris Metcalf <cmetcalf@tilera.com>
...
> ---
>  include/linux/smp.h |   22 ++++++++++++++++++++++
>  kernel/smp.c        |   29 +++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+), 0 deletions(-)
>


Milton made the very sensible comment that while adding on_each_cpu() in the
arch generic code and removing the two arch specific instances from tile and arm
in separate patches is good for review, it will break bisect.

He suggested I squash  them into a single commit when it goes in.

Since you picked the patch set into linux-mm, will now be a good time for that?

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
