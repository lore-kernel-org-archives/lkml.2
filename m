Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3ACXZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:25:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab3ACXZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:25:14 -0500
Date: Thu, 3 Jan 2013 15:25:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 20/32] aio: Give shared kioctx fields their own
 cachelines
Message-Id: <20130103152512.009513a1.akpm@linux-foundation.org>
In-Reply-To: <1356573611-18590-23-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-23-git-send-email-koverstreet@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012 17:59:59 -0800
Kent Overstreet <koverstreet@google.com> wrote:

>  	struct {
> -		struct mutex	ring_lock;
> +		atomic_t	reqs_active;
>  	} ____cacheline_aligned;

Is there a reason why this guy remains aligned on CONFIG_SMP=n?

