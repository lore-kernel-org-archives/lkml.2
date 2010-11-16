Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab0KPOcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:32:14 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37502 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933047Ab0KPOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:32:11 -0500
Date: Tue, 16 Nov 2010 15:31:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sync semantics.
Message-ID: <20101116143149.GC6527@ucw.cz>
References: <20101111125219.GA945@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111125219.GA945@bitwizard.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> What should I expect from a "sync" system call?
> 
> The manual says: 
> 
>    sync() first commits inodes to buffers, and then buffers to disk.
> 
> and then goes on to state: 
> 
>    ... since  version  1.3.20 Linux does actually wait.
> 
> [for the buffers to be handed over to the drive]
> 
> So how long can I expect a "sync" call to take? 
> 
> I would expect that all buffers that are dirty at the time of the
> "sync" call are written by the time that sync returns. I'm currently
> bombarding my fileserver with some 40-60Mbytes per second of data to
> be written (*). The fileserver has 8G of memory. So max 8000 Mb of

Are you sure? Hitting 40MB/sec is hard when it involves seeking...

You may want to lower dirty_ratio...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
