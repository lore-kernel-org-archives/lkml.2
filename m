Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2F2X6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:58:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47551 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab2F2X6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:58:10 -0400
Message-ID: <1341014197.2342.7.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Fri, 29 Jun 2012 19:56:37 -0400
In-Reply-To: <1341005929.2194.9.camel@falcor.watson.ibm.com>
References: <20120623210141.GK14083@ZenIV.linux.org.uk>
	 <20120624041652.GN14083@ZenIV.linux.org.uk>
	 <20120624153310.GB24596@redhat.com>
	 <20120625060357.GT14083@ZenIV.linux.org.uk>
	 <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
	 <20120628043836.GW14083@ZenIV.linux.org.uk>
		 <1340947838.2293.2.camel@falcor>
	 <20120629083311.GX14083@ZenIV.linux.org.uk>
	 <1340974925.2309.13.camel@falcor>
	 <20120629174130.GY14083@ZenIV.linux.org.uk>
	 <1341005929.2194.9.camel@falcor.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12062923-7282-0000-0000-00000A70A442
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 17:38 -0400, Mimi Zohar wrote:
> On Fri, 2012-06-29 at 18:41 +0100, Al Viro wrote:
> > On Fri, Jun 29, 2012 at 09:02:05AM -0400, Mimi Zohar wrote:
> > 
> > > In addition to failing with my tailored .config (eg. IMA, TPM builtin),
> > > it fails with config-3.4.2-1.fc16.x86_64, with new default options,
> > > running on a Lenovo W520.
> > > 
> > > /dev/sda7 on / type ext4 (rw,relatime,seclabel,i_version,data=ordered)
> > 
> > Lovely...  Smells like something making dracut unhappy.  Does it say
> > anything interesting when booting with rdinitdebug in command line?
> > What happens with rdshell in there?
> > 
> > I don't have easily accessible Fedora boxen at the moment and it does
> > look like something fishy going on while initramfs stuff runs...
> 
> No difference with rdinitdebug, rdshell, but the message 
> "ata5: SATA link down (SStatus 0 SControl 300)" prior to "Freeing unused
> kernel memory... ", "Failed to execute /init" and the trace back,
> probably helps.  Don't know how I missed that.

Looking at /var/log/messages, seems like the ata4 and ata5 "SATA link
down (SStatus 0 SControl 300)" messages are normal.

ata5: SATA link down (SStatus 0 SControl 300)
Freeing unused kernel memory: 1016k freed
Write protecting the kernel read-only data: 12288k
Freeing unused kernel memory: 1964k freed
Freeing unused kernel memory: 1468k freed
Failed to execute /init
Kernel panic - not syncing. No init Found.  Try passing init= option ...
Pid: 1, comm: swapper/0 not tainted 3.5.0-rc1+
Call Trace:
	panic
	init_post
	kernel_init
	?do_early_param
	kernel_thread_helper
	start_kernel

Mimi

