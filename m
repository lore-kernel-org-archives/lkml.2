Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0EWKTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 06:19:01 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:48343 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752334Ab0EWKTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 06:19:00 -0400
Date: Sun, 23 May 2010 20:18:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Roman Kononov <roman@binarylife.net>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100523101856.GL2150@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 12:20:23AM -0500, Roman Kononov wrote:
> Under some workload, once per ~10 seconds, I'm getting the following warnings
> with 2.6.32.13 and 2.6.33.4 (x86_64). Why are they?

You've got some workload that is mixing direct IO writes with some
form of buffered or mmap IO on the same file and they are racing.
Mixing different types of IO on the one inode is also known as A
Really Bad Idea because there is no guarantee of coherency between
them....

Can you find out what the application is triggering this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
