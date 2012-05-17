Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab2EQPJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:09:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:40034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759873Ab2EQPJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:09:05 -0400
Message-ID: <1337267329.4281.32.camel@twins>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Nick Piggin <npiggin@gmail.com>
Date: Thu, 17 May 2012 17:08:49 +0200
In-Reply-To: <1337266310.4281.30.camel@twins>
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
	 <1337133919-4182-3-git-send-email-minchan@kernel.org>
	 <4FB4B29C.4010908@kernel.org> <1337266310.4281.30.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 16:51 +0200, Peter Zijlstra wrote:
> 
> Also, does it even work if the range happens to be backed by huge pages?
> IIRC we try and do the identity map with large pages wherever possible. 

OK, the Intel SDM seems to suggest it will indeed invalidate ANY mapping
to that linear address, which would include 2M and 1G pages.
