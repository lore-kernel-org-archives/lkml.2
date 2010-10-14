Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0JNXbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:31:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004Ab0JNXbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:31:32 -0400
Date: Thu, 14 Oct 2010 16:30:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        lmcilroy@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] vfs: relax count check in rw_verify_area
Message-Id: <20101014163047.d909ad5c.akpm@linux-foundation.org>
In-Reply-To: <201010132246.21744.edward.shishkin@gmail.com>
References: <201010132246.21744.edward.shishkin@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 22:46:21 +0200
Edward Shishkin <edward.shishkin@gmail.com> wrote:

> Increase count limit in rw_verify_area().
> 

OK, now this is a truly awful attempt to describe a patch.

afaict what the patch does is to change rw_verify_area() so that the
kernel now permits single reads and writes of up to 2^63 bytes on
64-bit systems.  Whereas it was previously limited to 2^31.  And the
patch also fixes up a couple of callsites which were assuming that
rw_verify_area() had that particular behaviour.

But that's just my guess, based on a quick read of the implementation. 
I didn't check how far this change penetrates.  Does it affect all
filesystems, for example?  If so were they all reviewed (or tested!)
for correctness?

And why was this patch written?  What motivated you?  What are the
user-visible effects?  Do manpages need updating?

I don't want to have to sit here scratching my head over the
implications and intent of *your* patch.  As at least a starting
point, you should be telling us, please.

