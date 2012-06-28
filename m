Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab2F1KVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:21:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33138 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab2F1KVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:21:32 -0400
Date: Thu, 28 Jun 2012 12:21:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: BUG: scheduling while atomic: chcpu/6197/0x00000002
Message-ID: <20120628102139.GA21682@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Sattler <sattler@med.uni-frankfurt.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
References: <4FDF00CB.7090703@med.uni-frankfurt.de>
 <4FDF201E.2090408@med.uni-frankfurt.de>
 <4FE19494.6000303@med.uni-frankfurt.de>
 <4FE86067.9010408@med.uni-frankfurt.de>
 <4FEAF165.9090008@med.uni-frankfurt.de>
 <20120627174649.GA28137@x1.osrc.amd.com>
 <4FEBF277.90704@med.uni-frankfurt.de>
 <20120628064213.GC450@x1.osrc.amd.com>
 <4FEC22E8.5030707@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FEC22E8.5030707@med.uni-frankfurt.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 11:24:56AM +0200, Thomas Sattler wrote:
> > Any chance you could try a non-rt kernel,
> 
> Earlier in this thread I wrote, that 3.4.[23] are
> in fact unaffected. Only 3.4.[234]-rt1[0123] show
> this BUG in dmesg.
> 
> > to rule out an -rt issue?
> 
> Steven Rostedt wrote (w/o CC:LKML) that he believes
> CPU hotplug is still an issue with -rt. So, are you
> still interested to follow the "amd on intel" thing?

I don't think it is an "amd on intel" issue - it is probably the
stack trace dumping code wrongly finding the init_amd symbol due to
CPU_SUP_AMD bring compiled in or so...

Rather, it looks like the issue is what Steve said.

> > Also, looks like your cpu can do 64-bit. Can you
> > try a 64-bit kernel?
> 
> Yes, it's a 32-bit userland on 64-bit hardware. So
> far I didn't compile 64-bit kernels on 32-bit user-
> land but in case you're still interested in the
> result, I'll give it a try.

Well, if you have a 64-bit cpu, you could consider running a 64-bit
kernel for many reasons. The most important one being that 64-bit code
is enjoying orders of magnitude more testing because the world has moved
to 64-bit already. -rt included.

-- 
Regards/Gruss,
Boris.
