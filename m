Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab1CPKb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 06:31:27 -0400
Received: from smtp.nokia.com ([147.243.128.24]:57327 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1CPKbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 06:31:20 -0400
Subject: Re: linux-next: build failure after merge of the final tree (ubi
 tree related)
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ext Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1300270508.22236.1168.camel@pasglop>
References: <20110316175041.67c4f371.sfr@canb.auug.org.au>
	 <1300260170.2817.4.camel@localhost>  <1300270508.22236.1168.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Wed, 16 Mar 2011 12:27:37 +0200
Message-ID: <1300271257.2817.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 21:15 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2011-03-16 at 09:22 +0200, Artem Bityutskiy wrote:
> > On Wed, 2011-03-16 at 17:50 +1100, ext Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > > 
> > > drivers/mtd/ubi/io.c: In function 'ubi_dbg_check_write':
> > > drivers/mtd/ubi/io.c:1348: error: 'PAGE_KERNEL' undeclared (first use in this function)
> > > drivers/mtd/ubi/io.c: In function 'ubi_dbg_check_all_ff':
> > > drivers/mtd/ubi/io.c:1412: error: 'PAGE_KERNEL' undeclared (first use in this function)
> > > 
> > > Caused by commit 823ed5091113 ("UBI: allocate write checking buffer on demand").
> > > 
> > > I don't know how to fix this, so I have left it for today.
> > 
> > Hmm, strange, include <linux/vmalloc.h> should be enough to use
> > __vmalloc with 'PAGE_KERNEL' AFAICS, and we have this include... I'll
> > try to look better.
> 
> Try adding asm/pgtable.h 

Thanks, that's what I was thinking about as well.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

