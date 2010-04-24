Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0DXWaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 18:30:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61240 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0DXWay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 18:30:54 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Date: Sun, 25 Apr 2010 00:30:40 +0200
User-Agent: KMail/1.9.10
Cc: xfs@oss.sgi.com, Nick Piggin <npiggin@suse.de>,
       opensuse-kernel@opensuse.org, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <201004050049.17952.hpj@urpla.net> <201004241844.23482.hpj@urpla.net> <20100424232320.71f764eb@galadriel.home>
In-Reply-To: <20100424232320.71f764eb@galadriel.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201004250030.40867.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX184wf7HJKX6UJ6R5fOrYUxXEQqADI37jYj2O0j
 YWEj6Y393PmtQwymORZDFM+T7X3IqUIqCabiunU4n445TN49s+
 yJJNaVZpSEVfMmpVqDo42gC0PLP2izn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 April 2010, 23:23:20 Emmanuel Florac wrote:
> Le Sat, 24 Apr 2010 18:44:22 +0200 vous écriviez:
> > Greg, you might search for a server using xfs filesystems and and a
> > i586 kernel >= 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well),
> > log in as an ordinary user, do a "du" on /usr, and wait for the other
> > users screaming...
>
> I did precisely that, and didn't notice anything special (du on kernel
> source tree) kernel 2.6.32.11, deadline scheduler, 7 drives RAID-6
> array, 8GB RAM.

I guess, you're not on this specific openSUSE git version of 2.6.32.11 (e.g. 
the preparation for SP1 of SLE11), which, as usual, carries a lot of stuff 
from later kernels. The offending patch was included in linux-2.6.33 
between -rc4 and -rc5:

Committer
Alex Elder<aelder@sgi.com>
Author
Dave Chinner<david@fromorbit.com>
Author date
11.01.10 00:51
Parent
xfs: Avoid inodes in reclaim when flushing from inode cache
Child
xfs: Remove inode iolock held check during allocation
Branch
master origin (Merge branch 'for-linus' of git://git.kernel.org/pub/scm/...) 
Branch
2.6.33.1 (Linux 2.6.33) 
Follows
v2.6.33-rc4 (Linux 2.6.33-rc4)
Precedes
v2.6.33-rc5 (Linux 2.6.33-rc5)

Cheers,
Pete
