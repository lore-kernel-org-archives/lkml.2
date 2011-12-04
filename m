Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1LDVA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 16:00:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47224 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1LDVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 16:00:28 -0500
Date: Sun, 4 Dec 2011 21:00:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is there a reason hard links from /proc/$PID/fd/$NUM are
 disallowed?
Message-ID: <20111204210027.GA2203@ZenIV.linux.org.uk>
References: <20111204204044.10290.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111204204044.10290.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 03:40:44PM -0500, George Spelvin wrote:
> I was trying to save a large file that was in mid-download that I had
> accidentally deleted (as part of making space in /tmp to hold the file!).
> 
> Since it was being held open by the download process, I tried
> 
> ln /proc/$PID/fd/$FD /tmp/bigfile.mp4

You do realize that link(2) does *NOT* follow links, do you?  linkat(2)
does, if you explicitly ask for that:

linkat(AT_FDCWD, "/proc/42/fd/1", AT_FDCWD, "/tmp/foo", AT_SYMLINK_FOLLOW)

will do it just fine.
