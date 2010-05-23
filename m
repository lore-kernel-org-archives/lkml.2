Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0EWOXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 10:23:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45524 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308Ab0EWOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 10:23:46 -0400
X-Sasl-enc: a7wWClySgyiqv513GizjPSi2AcPqz7XBfAR44DolpZx0 1274624625
Date: Sun, 23 May 2010 09:23:44 -0500
From: Roman Kononov <roman@binarylife.net>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100523092344.0fcaab42@aaa.pulp.binarylife.net>
In-Reply-To: <20100523101856.GL2150@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
> You've got some workload that is mixing direct IO writes with some
> form of buffered or mmap IO on the same file and they are racing.
> Mixing different types of IO on the one inode is also known as A
> Really Bad Idea because there is no guarantee of coherency between
> them....
> 
> Can you find out what the application is triggering this?

This is severely modified Postgresql, which does mix direct IO with
buffered one.

You say "they are racing". Do you mean that this can cause file system
corruption? Doest it simply warn that direct user data races with
buffered user data and one of them wins? This warning "taints" the
kernel. Should it be safe to do different types of IOs on different
non-overlapping 4-KiB-aligned regions of the same file (I am unsure
if this is what the application really does)?

Thanks,

Roman
