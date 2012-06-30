Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab2F3FCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:02:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36802 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2F3FCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:02:47 -0400
Date: Sat, 30 Jun 2012 06:02:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120630050238.GZ14083@ZenIV.linux.org.uk>
References: <20120625060357.GT14083@ZenIV.linux.org.uk>
 <20120625151812.GA16062@redhat.com>
 <20120627183721.GA23086@redhat.com>
 <20120628043836.GW14083@ZenIV.linux.org.uk>
 <1340947838.2293.2.camel@falcor>
 <20120629083311.GX14083@ZenIV.linux.org.uk>
 <1340974925.2309.13.camel@falcor>
 <20120629174130.GY14083@ZenIV.linux.org.uk>
 <1341005929.2194.9.camel@falcor.watson.ibm.com>
 <1341014197.2342.7.camel@falcor.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341014197.2342.7.camel@falcor.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 07:56:37PM -0400, Mimi Zohar wrote:
> Looking at /var/log/messages, seems like the ata4 and ata5 "SATA link
> down (SStatus 0 SControl 300)" messages are normal.
> 
> ata5: SATA link down (SStatus 0 SControl 300)
> Freeing unused kernel memory: 1016k freed
> Write protecting the kernel read-only data: 12288k
> Freeing unused kernel memory: 1964k freed
> Freeing unused kernel memory: 1468k freed
> Failed to execute /init
> Kernel panic - not syncing. No init Found.  Try passing init= option ...
> Pid: 1, comm: swapper/0 not tainted 3.5.0-rc1+
> Call Trace:
> 	panic
> 	init_post
> 	kernel_init
> 	?do_early_param
> 	kernel_thread_helper
> 	start_kernel

Just to make sure - you are not getting IMA violations among all that?  AFAICS,
the damn thing should behave no worse in that respect than your own patch
a while ago, and you haven't mentioned them in this thread, but...
