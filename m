Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab2C3K1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:27:02 -0400
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:40558 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663Ab2C3K05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:26:57 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2012 06:26:56 EDT
Date: Fri, 30 Mar 2012 12:21:21 +0200
From: David Madore <david+ml@madore.org>
To: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>
Subject: since when does linkat() on deleted /proc/$PID/fd/$num return
 ENOENT ?
Message-ID: <20120330102121.GA5999@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It used to be the case (last time I checked was around late 2008 or
early 2009) that deleted entries from /proc/$PID/fd/ could be linked
back to the filesystem by using linkat(,,,,AT_SYMLINK_FOLLOW).

Now this just returns ENOENT.

I'd like to understand when, how and why this change took place.  What
commit introduced it and was it a deliberate move (e.g., because the
feature was a security issue of itself, or came into conflict with
something else) or was it accidental?  Does it depend on the /proc
filesystem itself or on the target filesystem where the deleted file
used to reside?

(There's a Reddit thread, <URL:
http://www.reddit.com/r/programming/comments/7yx6f/how_to_undelete_any_open_deleted_file_in_linux/
 >, where some people are reporting ENOENT on 2.6.27 or perhaps even
2.6.26, which helps but a bound on the change.)

(See also this thread: <URL:
http://comments.gmane.org/gmane.linux.kernel/1224071
 >, where the question is not answered, however.)

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
