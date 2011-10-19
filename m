Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1JSVT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:19:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60550 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1JSVT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <20111014153844.GP14968@somewhere>
References: <1317943022.1095.25.camel@mop> <20111011161600.6145aa6b.akpm@linux-foundation.org>
 <20111012005935.GD14968@somewhere> <20111012174014.GE6281@google.com>
 <20111012181641.GZ15413@moon> <20111014153844.GP14968@somewhere>
From: Paul Menage <paul@paulmenage.org>
Date: Wed, 19 Oct 2011 14:19:37 -0700
X-Google-Sender-Auth: FRlcouRAGjCTAPsAFwP4DmHCGR0
Message-ID: <CALdu-PAMNK5dBAf9kB8_uQf8uQhrzSfRm+4sOqTG40KjsG5U+A@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_A_Plumber=92s_Wish_List_for_Linux?=
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Oleg Nesterov <oleg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 8:38 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> Well, wouldn't it be better to pull that complexity to userspace?
> After all, moving tasks from a cgroup to another is not a performance
> critical operation so that probably doesn't need to be all handled by
> the kernel.

I'd always assumed that too, but apparently on very many (possibly the
majority of?) Linux systems, it actually is performance-critical.

Specifically, Android bounces tasks in and out of a "foreground
low-latency" cpu cgroup at a fairly high rate, and has found the
performance hit from the locking to be a problem on multi-core phones.
Hence Colin Cross' patches for avoid calls to synchronize_rcu() in the
attach path.

Paul
