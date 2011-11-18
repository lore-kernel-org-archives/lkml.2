Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab1KRGv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 01:51:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1KRGv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 01:51:58 -0500
Date: Thu, 17 Nov 2011 22:52:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: account reaped page cache on inode cache pruning
Message-Id: <20111117225202.3535aba3.akpm@linux-foundation.org>
In-Reply-To: <4EC5FE6A.3080003@openvz.org>
References: <20111116134713.8933.34389.stgit@zurg>
	<20111117162322.1c3e3d05.akpm@linux-foundation.org>
	<4EC5FE6A.3080003@openvz.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 10:42:50 +0400 Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Do we really need separate on-stack reclaim_state structure with single field?
> Maybe replace it with single long (or even unsigned int) .reclaimed_pages field on task_struct
> and account reclaimed pages unconditionally.

I don't think it matters a lot - it's either a temporary pointer on the
stack or a permanent space consumption in the task_struct.

The way thing are at present we can easily add new fields if needed.  I
don't think we've ever done that though.
