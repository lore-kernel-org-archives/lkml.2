Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1AIVzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:55:49 -0500
Received: from mail.solarflare.com ([216.237.3.220]:4807 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1AIVzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:55:47 -0500
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and
 coding-style
From: Ben Hutchings <bhutchings@solarflare.com>
To: christoph.paasch@uclouvain.be
Cc: Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201101092232.19171.christoph.paasch@uclouvain.be>
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
	 <20110109130608.5c7bb4b0.rdunlap@xenotime.net>
	 <201101092232.19171.christoph.paasch@uclouvain.be>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Sun, 09 Jan 2011 21:55:41 +0000
Message-ID: <1294610141.2823.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2011 21:55:47.0114 (UTC) FILETIME=[F8A858A0:01CBB047]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17882.004
X-TM-AS-Result: No--28.007900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 22:32 +0100, Christoph Paasch wrote:
> Hello,
> 
> On Sunday, January 09, 2011 wrote Randy Dunlap:
> > On Sun,  9 Jan 2011 21:55:34 +0100 Christoph Paasch wrote:
> > If there is something in net/tcp.h that uses data or functions from
> > <linux/list.h>, then <linux/list.h> should be #included in net/tcp.h,
> > whether some other file pulls it in indirectly or not.
> > 
> > etc. etc. etc.
> Why?
> 
> IMHO I think that it increases compile-time.
> Ok, here in that case it only increases it slightly (probably it isn't even 
> measurable).

The cost of repeated inclusion is minimal.  GCC's preprocessor
recognises when the entire content of a file is conditional on #ifndef
FOO and will not even open it again if FOO is defined.

>  But, if *all* the files would be more strict in including, I'm 
> sure that it would make a difference.
> The less files you include, the faster the compilation will be.
> 
> In net/tcp.h there were even 4 unnecessary included files.
> 
> And, then we would also need to include:
> net/net_namespace.h (for struct net)
> 
> Also, I think that it makes the code more readable and also easier to 
> maintain. The more files we include, the bigger the chance is that we will end 
> up with plenty of files unnecessarily included, and thus the compile-time will 
> explode.

If a file directly references definitions that are supposed to be
provided by a certain header, changing it to rely on indirect inclusion
of that header generally does *not* aid maintenance.

(There are some cases where you should rely on indirect inclusion, such
as where <linux/foo.h> includes <asm/foo.h>.)

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

