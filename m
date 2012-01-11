Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2AKRCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:02:46 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37330 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757727Ab2AKRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:02:44 -0500
X-Sasl-enc: 0lIfFhQZZNj1Nkj8eY8fk0NB3F1noQwdMslv6qmlXTIG 1326301362
Date: Wed, 11 Jan 2012 08:59:10 -0800
From: Greg KH <greg@kroah.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jun Ma <harry.majun@huawei.com>,
        stable@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH] kprobes: fix a memory leak in function
 pre_handler_kretprobe()
Message-ID: <20120111165910.GB2794@kroah.com>
References: <1326295311-10985-1-git-send-email-jiang.liu@huawei.com>
 <20120111161233.GA13539@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111161233.GA13539@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 09:42:33PM +0530, Ananth N Mavinakayanahalli wrote:
> On Wed, Jan 11, 2012 at 11:21:51PM +0800, Jiang Liu wrote:
> > From: Jiang Liu <liuj97@gmail.com>
> > 
> > In function pre_handler_kretprobe(), the allocated kretprobe_instance object
> > will be leaked if the entry_handler callback returns non-zero. This may cause
> > all the preallocated kretprobe_instance objects exhausted. This issue could be
> > reproduced by changing samples/kprobes/kretprobe_example.c to probe 
> > "mutex_unlock". And the fix is straight forward, just put the allocated 
> > kretprobe_instance object back onto the free_instances list. 
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> > Acked-by: Jim Keniston <jkenisto@us.ibm.com>
> > Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Thank you Jiang. I think the correct ID for stable is now
> stable@vger.kernel.org.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
