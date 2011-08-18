Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1HRHfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:35:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44853 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1HRHe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:34:58 -0400
Date: Thu, 18 Aug 2011 09:34:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
Message-ID: <20110818073452.GE13572@htj.dyndns.org>
References: <20110816190858.GA4890@redhat.com>
 <20110816192629.GB2803@mtj.dyndns.org>
 <20110817172713.GA24544@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817172713.GA24544@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 17, 2011 at 07:27:13PM +0200, Oleg Nesterov wrote:
> Btw. Perhaps we should kill CLONE_KERNEL? And note that the only
> user is eeh_thread_launcher().
> 
> The problem is, CLONE_KERNEL looks as "use me if you want to create
> a kernel thread". But CLONE_SIGHAND means the kernel thread should
> not play with signals, and this is not obvious.

I guess it predates kthread().  There's no reason to use
kernel_thread() directly outside of a few core places, so removing it
sounds like a pretty good idea.

Thanks.

-- 
tejun
