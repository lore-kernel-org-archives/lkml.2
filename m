Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2GaKhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:37:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54889 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2GaKeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:34:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120731144054.59b0a6da6d071ea1bc061db0@canb.auug.org.au>
References: <20120731144054.59b0a6da6d071ea1bc061db0@canb.auug.org.au>
Date: Tue, 31 Jul 2012 03:34:12 -0700
Message-ID: <CANN689FGMfL_Y3afhYbmSdvQH4tU+7CErODb=NoqAZnmoZEa3w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
From: Michel Lespinasse <walken@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sage Weil <sage@inktank.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 9:40 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> net/ceph/osd_client.c: In function 'ceph_osdc_alloc_request':
> net/ceph/osd_client.c:216:2: error: implicit declaration of function 'rb_init_node' [-Werror=implicit-function-declaration]
>
> Caused by commit 753b960e52b7 ("rbtree: empty nodes have no color") from
> the akpm tree interacting with commit cd43045c2de6 ("libceph: initialize
> rb, list nodes in ceph_osd_request") from the ceph tree.
>
> I added the following merge fix patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 31 Jul 2012 14:37:35 +1000
> Subject: [PATCH] libceph: remove rb_node initialisation
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
