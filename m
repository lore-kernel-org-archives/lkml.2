Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1HOLOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:14:43 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:57052 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1HOLOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:14:39 -0400
MIME-Version: 1.0
In-Reply-To: <4E48FD8A.90401@parallels.com>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
	<1313334832-1150-4-git-send-email-glommer@parallels.com>
	<CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>
	<20110815104656.GG26978@dastard>
	<CAOJsxLGFJmqO-W=itQbO4Mh4DxSD4wrHOC8gQ5bWL5aE1YYeQw@mail.gmail.com>
	<4E48FD8A.90401@parallels.com>
Date: Mon, 15 Aug 2011 14:14:39 +0300
X-Google-Sender-Auth: OBrdunw0EaZZKWdtgT7bLwhelMA
Message-ID: <CAOJsxLFjZffC9i5kQsBWjGy3eWdj3VMB5awz=yPcwgeKb5BG0Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
From: Pekka Enberg <penberg@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <jbottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Mon, Aug 15, 2011 at 2:05 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
> This will make sense, since the kernel memory management per-cgroup is one of the
> things we'd live to have, but this particular idea will definitely not work in case
> we keep the containers' files on one partition keeping each container in its own
> chroot environment.

And you want a per-container dcache limit? Will the containers share
the same superblock? Couldn't you simply do per-container "struct
kmem_accounted_cache" in struct superblock?

                        Pekka
