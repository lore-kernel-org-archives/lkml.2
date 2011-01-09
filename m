Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1AIXGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:06:37 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:7336 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1AIXGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:06:33 -0500
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and
 coding-style
From: Ben Hutchings <bhutchings@solarflare.com>
To: christoph.paasch@uclouvain.be
Cc: Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201101092333.19406.christoph.paasch@uclouvain.be>
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
	 <201101092232.19171.christoph.paasch@uclouvain.be>
	 <1294610141.2823.31.camel@localhost>
	 <201101092333.19406.christoph.paasch@uclouvain.be>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Sun, 09 Jan 2011 23:06:29 +0000
Message-ID: <1294614389.2823.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2011 23:06:32.0824 (UTC) FILETIME=[DB4C4780:01CBB051]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17882.004
X-TM-AS-Result: No--23.986400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 23:33 +0100, Christoph Paasch wrote:
> On Sunday, January 09, 2011 wrote Ben Hutchings:
> > The cost of repeated inclusion is minimal.  GCC's preprocessor
> > recognises when the entire content of a file is conditional on #ifndef
> > FOO and will not even open it again if FOO is defined.
> Thanks, I did not knew about that.
> 
> > If a file directly references definitions that are supposed to be
> > provided by a certain header, changing it to rely on indirect inclusion
> > of that header generally does *not* aid maintenance.
> But then, to be coherent, we would need to add the following includes (and I'm 
> even not 100% sure if it's all we need):
> 
> linux/percpu_counter.h (needed for percpu_counter_sum_positive)

Yes.

> linux/mm_types.h (needed for struct page)
> linux/aio.h (needed for struct kiocb)
> net/inet_sock.h (needed for struct ip_options)
> linux/pipe_fs_i.h (needed for struct pipe_inode_info)
> linux/poll.h (needed for struct poll_table_struct)

Or declarations of those structs.

> linux/compiler.h (needed for __percpu)
[...]

Yes.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

