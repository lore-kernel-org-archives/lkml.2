Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2DDXFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:05:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2DDXFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:05:46 -0400
Date: Wed, 4 Apr 2012 16:05:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] IPC: message queue receive cleanup
Message-Id: <20120404160544.f60c2150.akpm@linux-foundation.org>
In-Reply-To: <20120215165431.27978.36457.stgit@localhost6.localdomain6>
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
	<20120215165431.27978.36457.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 20:54:31 +0400
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> This patch moves all message related manipulation into one function msg_fill().
> Actually, two functions because of the compat one.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> ---
>  arch/tile/kernel/compat.c |   11 +----------
>  include/linux/compat.h    |    2 ++
>  include/linux/msg.h       |    5 +++--
>  ipc/compat.c              |   33 +++++++++++++++++----------------
>  ipc/msg.c                 |   44 +++++++++++++++++++++++---------------------

The arch/tile/kernel/compat.c change throws a big reject against
current mainline because the code it is patching has disappeared and I
didn't check where it went.  Check this, please?

Arnd, could you please pass an eye across this work?  Thanks.
