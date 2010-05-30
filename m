Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0E3Mcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:32:55 -0400
Received: from THUNK.ORG ([69.25.196.29]:34254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0E3Mcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:32:54 -0400
Date: Sun, 30 May 2010 08:32:48 -0400
From: tytso@mit.edu
To: Peter Hallberg <hallberg68@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What happened to mount option "noextents"
Message-ID: <20100530123248.GO26177@thunk.org>
Mail-Followup-To: tytso@mit.edu, Peter Hallberg <hallberg68@hotmail.com>,
	linux-kernel@vger.kernel.org
References: <COL116-W195C862FD57AC7C2144804DAED0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <COL116-W195C862FD57AC7C2144804DAED0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 02:07:06PM +0200, Peter Hallberg wrote:
> 
> On Ubuntu 9.04 it is possible to mount an ext4 file system with the
> mount option "noextents" but on Ubuntu 10.04 it gives the error
> message: Ext4: Unrecognized mount option "noextents" in dmesg.

Both the "extents" and "noexents" mount options were removed in newer
kernels.  If you want to turn on extents, the right answer is to use
the "tune2fs -O extents" command.  The "noextents" mount option didn't
really make much sense, since it basically was either no-op (if
extents were not enabled), and was mostly useless (if extents were
enabled in the file system), since it basically meant, "create new
files without using extents".  But since the old files were still
extents-based, it didn't make the file system any more compatible with
ext3 file systems.

Basically, since we couldn't think of a good use case where the mount
options made sense, and ext4 has way too many mount options already, we
decided to remove them.

						- Ted
