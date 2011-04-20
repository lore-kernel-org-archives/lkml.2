Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1DTNnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:43:14 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47594 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753016Ab1DTNnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:43:13 -0400
Date: Wed, 20 Apr 2011 12:57:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Implement /dev/byte (a generic byte source
 similiar to /dev/zero)
Message-ID: <20110420105754.GA14722@ucw.cz>
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>
 <1303126676-3456-2-git-send-email-holler@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303126676-3456-2-git-send-email-holler@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-04-18 13:37:56, Alexander Holler wrote:
> This device outputs by default 0xff instead 0 which makes more sense
> than 0 to clear e.g. FLASH based devices.

Well, now you should provide example where you mmap /dev/byte, then
write() the flash directly from the mapping.

... hmm, that brings good question: what happens on existing mappings
when the byte is changed?

> To make the device more general usable, the value it outputs is changeable
> on a per file descriptor basis through simple writes to it.
> Values can be decimal (0 - 255), octal (00 - 0377) or hex (0x0 - 0xff).
> For other values (or strings) written to it, the write operation returns an
> error and the subsequent output is undefined.
...
>  # Create a file of size 10GB and filled with 0xaa.
> exec 5<>/dev/byte # Open /dev/byte and assign fd 5 to it
> echo 0xaa >&5     # Instruct the device to output 0xaa

That's seriously strange. /dev/byte should be changeable... by writing
bytes.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
