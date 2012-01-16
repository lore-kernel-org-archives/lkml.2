Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2APNIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:08:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41400 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2APNIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:08:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120116112802.GB7180@jl-vm1.vm.bytemark.co.uk>
References: <1326544511-6547-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120116112802.GB7180@jl-vm1.vm.bytemark.co.uk>
Date: Mon, 16 Jan 2012 18:38:33 +0530
Message-ID: <CAAHN_R1u_btMuF+WhHu0G895EJ=mbOPNRp7NcXEgTKv3Vs-B1A@mail.gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 4:58 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Is there a reason the names aren't consistent - i.e. not vma_is_stack_guard()?

Ah, that was an error on my part; I did not notice the naming convention.

> How about simply calling it vma_is_guard(), return 1 if it's PROT_NONE
> without checking vma_is_stack() or ->vm_next/prev, and annotate the
> maps output like this:
>
>   is_stack              => "[stack]"
>   is_guard & is_stack   => "[stack guard]"
>   is_guard & !is_stack  => "[guard]"
>
> What do you think?

Thanks for the review. We're already marking permissions in the maps
output to convey protection, so isn't marking those vmas as [guard]
redundant?

Following that, we could just mark the thread stack guard as [stack]
without any permissions. The process stack guard page probably
deserves the [stack guard] label since it is marked differently from
the thread stack guard and will otherwise have the permissions that
the process stack has. Will that be good?

-- 
Siddhesh Poyarekar
