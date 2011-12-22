Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1LVP6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:58:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52260 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1LVP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:58:20 -0500
MIME-Version: 1.0
In-Reply-To: <20111222152009.GB1388@redhat.com>
References: <20111222001800.GL9213@google.com>
	<20111222001939.GM9213@google.com>
	<20111222004629.GO9213@google.com>
	<20111221170919.f7d49fc6.akpm@linux-foundation.org>
	<20111222012312.GP9213@google.com>
	<20111222151529.GA1388@redhat.com>
	<20111222152009.GB1388@redhat.com>
Date: Thu, 22 Dec 2011 07:58:18 -0800
X-Google-Sender-Auth: hAAwzN8tkPdtElrn2Djtsbvwczs
Message-ID: <CAOS58YN3hvnXofcz9WVER_bV2KwG+=mqoaJ8zRx2nsoHdpH4wQ@mail.gmail.com>
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 7:20 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Also mempool expects all the objects to be returned to the pool at the
> time of destroy. Given the fact that blkio groups are reference counted,
> theoritically they can be freed later.

I removed that part but no you still can't free objects after mempool
destruction refcnted or not. mempool is destructed on module unload.
Which text would free those objects? If that's theoretically possible,
the code is broken.

Thanks.

-- 
tejun
