Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab2LITyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 14:54:08 -0500
Received: from fly.hiwaay.net ([216.180.54.1]:33393 "EHLO fly.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934440Ab2LITyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 14:54:07 -0500
X-Greylist: delayed 992 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2012 14:54:07 EST
Date: Sun, 9 Dec 2012 13:37:33 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: New system call wanted: fdreopen
Message-ID: <20121209193733.GA15378@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ka2982$ra3$1@ger.gmane.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Tristan Wibberley  <tristan.wibberley@gmail.com> said:
>A common idiom on Linux is to open a file and keep the fd open so that 
>the underlying file can be unlinked from its directory. But if the file 
>needs to be read from several different parts of the codebase then due to 
>the file descriptor having exactly one read pointer those different parts 
>must be synchronised which is a relatively difficult task.

I think you can get similar behavior entirely in user space and in a
fashion portable to at least BSD systems.  You could fork() (which would
create a separate FD in the child), pass the FD back to the parent over
a socket, and then have the child exit.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
