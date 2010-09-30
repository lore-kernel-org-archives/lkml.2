Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0I3Ev2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:51:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591Ab0I3Ev0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:51:26 -0400
Date: Wed, 29 Sep 2010 21:52:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] fs: icache lock i_count
Message-Id: <20100929215229.160c7bce.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-6-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-6-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:37 +1000 Dave Chinner <david@fromorbit.com> wrote:

> -	if (atomic_read(&inode->i_count) != 1)
> +	if (inode->i_count != 1)

This really should have been renamed to catch unconverted code.

Such code usually wouldn't compile anyway, but it will if it takes the
address of i_count only (for example).

And maybe we should access this guy via accessor functions, dunno.
