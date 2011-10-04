Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1JDJiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 05:38:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab1JDJiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 05:38:01 -0400
Date: Tue, 4 Oct 2011 11:37:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm00@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kmod: prevent kmod_loop_msg overflow in
 __request_module()
In-Reply-To: <87zkhhhap3.fsf@rustcorp.com.au>
Message-ID: <alpine.LNX.2.00.1110041135340.31654@pobox.suse.cz>
References: <alpine.LNX.2.00.1109291749000.24692@pobox.suse.cz> <20110929143129.e7c3c7e2.akpm00@gmail.com> <alpine.LNX.2.00.1109292337030.24692@pobox.suse.cz> <87zkhhhap3.fsf@rustcorp.com.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011, Rusty Russell wrote:

> > > Well, it will take two billion passes through here to cause the
> > > overflow.  I really hope you found this problem by inspection!
> > 
> > Unfortunately not, it was more painful experience than code reading :)
> 
> Cool!
> 
> Changing it to unsigned would have helped too.  

Still woudln't have helped much in cases of __request_module() being 
called incredibly quickly in an infinite loop. Changing it to unsigned 
will cause the messages being printed in bunches of five, but the effect 
will be the same -- the log being infinitely filled by the printk()s. 
Computers can do infinite loops really quickly today :)

-- 
Jiri Kosina
SUSE Labs
