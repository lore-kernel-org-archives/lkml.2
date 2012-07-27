Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2G0O22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:28:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57892 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2G0O20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:28:26 -0400
Message-ID: <1343399335.7767.6.camel@cwalton-XPS-8300>
Subject: Re: [BUG] NTFS code doesn't sanitize folder names sufficiently
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Marian Beermann <public@enkore.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Date: Fri, 27 Jul 2012 10:28:55 -0400
In-Reply-To: <501189DA.4030709@enkore.de>
References: <501189DA.4030709@enkore.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 20:18 +0200, Marian Beermann wrote:
> Hello everyone,
> 
> today I noticed some very odd behaviour, which could lead people to 
> believe a loss of data, because it is possible to create directories 
> with backslashes in them.
> 
> I am currently running kernel 3.5.
> 
> To completly reproduce the problem to the full extend you'll need a 
> Windows computer, but to see whats wrong Linux completly suffices :-)
> 
> On a Linux computer
> 1. Create a directory named TestA on an NTFS partition
> 2. Create a subdirectory of TestA named TestB
> 3. Create a third directory alongside TestA named TestA\TestB (the 
> fundamental problem is this: backslashes in directory names)

If you're writing new directories to an NTFS partition, it's very
probable that you're not actually using the in-kernel NTFS driver at
all. It's more likely that you have the userspace (FUSE) NTFS driver
instead:
http://www.tuxera.com/community/ntfs-3g-download/

In fact, they have a FAQ about it the issue that you're seeing:
http://www.tuxera.com/community/ntfs-3g-faq/#posixfilenames2
You use the 'windows_names' mount option to disable creating file and
directory names that confuse windows.

Linux itself (and most native Linux programs) has no issues with
directory names containing the '\' character, of course; the only
characters that you cannot use are '/' and ASCII NUL, 0x00.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

