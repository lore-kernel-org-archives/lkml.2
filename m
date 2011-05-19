Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1ESOmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:42:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab1ESOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:42:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH 0/14] Fix HPFS
Date: Thu, 19 May 2011 16:42:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <alpine.DEB.2.00.1105082019230.7013@artax.karlin.mff.cuni.cz>
In-Reply-To: <alpine.DEB.2.00.1105082019230.7013@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191642.00233.arnd@arndb.de>
X-Provags-ID: V02:K0:L0fV+2J4X3Hlgdaaa0XmHtdLLIK9X/1vil04dUDK9bR
 N8q5XBKm714Q8hdbaDVBi23BBYgv2AaEQVLP6/v9Niwiq5e7Wb
 PKdVzyv5Z5O2LrmNtFKbqTykxtw+LB02AKO6Woe7bryPC+UrgK
 4J1mYDV62kFLSCKPPnBscaGL8CrPYywg6Bv4B+gA839hz5nFgZ
 2uLMU+Mr5UceUnlsn09iQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 May 2011, Mikulas Patocka wrote:
> This series of patches fixes the HPFS filesystem in 2.6.39. HPFS was 
> broken in 2.6.39-rc1 due to big kernel lock removal. These patches also 
> make it portable, I tested it on big endian machines.

Thanks for picking it up again after I made it UP-only!

> BTW. would you also like to commit my another filesystem (SpadFS) to the 
> Linux kernel? It is at 
> http://artax.karlin.mff.cuni.cz/~mikulas/spadfs/download/spadfs-0.9.12.tar.gz
> It is very small (300kB), it uses crash counts instead of journaling to 
> keep itself consistent, it stores inodes directly in directories, saving 
> one seek on opening files and it uses extendible hashing for directory 
> organization.

There is a nonzero maintainance overhead that comes with every file
system getting added to the kernel, plus the pain that comes with
potential security problems and maintaining backwards compatibility
with an installed user base. 300kb is not extremely small for a
new file system either, it's actually slightly larger than ext2.

If you can provide a convincing argument why the code is useful
to other people and what it does that no other file system today
can do, we can start looking at the patch. My initial impression
from looking at it is that it's fairly clean code, I'm just missing
the point of why I would want to use it.

	Arnd
