Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab1IMUvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:51:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32177 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab1IMUvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:51:12 -0400
MIME-Version: 1.0
Message-ID: <f477a147-9948-4bef-973a-1f77bd185da1@default>
Date: Tue, 13 Sep 2011 13:50:27 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        kamezawa.hiroyu@jp.fujitsu.com, jackdachef@gmail.com,
        cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: RE: [PATCH V9 3/6] mm: frontswap: core frontswap functionality
References: <20110913174026.GA11298@ca-server1.us.oracle.com
 4E6FBFC4.1080901@linux.vnet.ibm.com>
In-Reply-To: <4E6FBFC4.1080901@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4E6FC22D.0004,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH V9 3/6] mm: frontswap: core frontswap functionality
> 
> Hey Dan,
> 
> I get the following compile warnings:
> 
> mm/frontswap.c: In function 'init_frontswap':
> mm/frontswap.c:264:5: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer
> type
> include/linux/debugfs.h:68:16: note: expected 'size_t *' but argument is of type 'long unsigned int *'
> mm/frontswap.c:266:5: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer
> type
> include/linux/debugfs.h:68:16: note: expected 'size_t *' but argument is of type 'long unsigned int *'
> mm/frontswap.c:268:5: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer
> type
> include/linux/debugfs.h:68:16: note: expected 'size_t *' but argument is of type 'long unsigned int *'
> mm/frontswap.c:270:5: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer
> type
> include/linux/debugfs.h:68:16: note: expected 'size_t *' but argument is of type 'long unsigned int *'

Thanks for checking on 32-bit!
 
> size_t is platform dependent but is generally "unsigned int"
> for 32-bit and "unsigned long" for 64-bit.
> 
> I think just typecasting these to size_t * would fix it.

Actually, I think the best fix is likely to change the variables
and the debugfs calls to u64 since even on 32-bit, the
counters may exceed 2**32 on a heavily-loaded long-running
system.

I'll give it a day or two to see if anyone else has any feedback
before I fix this for V10.

Dan
