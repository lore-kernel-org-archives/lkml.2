Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1AaWkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:40:22 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45337 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1AaWkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:40:20 -0500
Subject: Re: kswapd hung tasks in 2.6.38-rc1
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: CAI Qian <caiqian@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
        aarcange <aarcange@redhat.com>
In-Reply-To: <1296507528.7797.4609.camel@nimitz>
References: <1150342867.83404.1295513748640.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	 <1296507528.7797.4609.camel@nimitz>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 31 Jan 2011 14:40:16 -0800
Message-ID: <1296513616.7797.4929.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 12:58 -0800, Dave Hansen wrote:
> On Thu, 2011-01-20 at 03:55 -0500, CAI Qian wrote:
> > When running LTP oom01 [1] testing, the allocation process stopped
> > processing right after starting to swap.
> 
> I'm seeing the same stuff, but on -rc2.  I thought it was
> transparent-hugepage-related, but I don't see much of a trace of it in
> the stack dumps.
> 
> http://sr71.net/~dave/ibm/config-v2.6.38-rc2
> 
> It happened to me as well around the time that things started to hit
> swap.

Still not a very good data point, but I ran a heavy swap load for an
hour or so without reproducing this.  But, it happened again after I
enabled transparent huge pages.  I managed to get a sysrq-t dump out of
it:

	http://sr71.net/~dave/ibm/2.6.38-rc2-hang-0.txt

khugepaged is one of the three running tasks.  Note, I set both its
sleep timeouts to zero to stress it out a bit.

I'll keep trying to reproduce without THP.

-- Dave

