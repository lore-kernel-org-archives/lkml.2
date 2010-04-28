Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0D1RZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:25:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:57752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0D1RZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:25:01 -0400
Message-ID: <4BD86F3D.7040907@kernel.org>
Date: Wed, 28 Apr 2010 19:24:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Greg KH <greg@kroah.com>, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [171/197] module: fix __module_ref_addr()
References: <20100422191857.GA13268@kroah.com>	<20100422190922.702027944@kvm.kroah.org>	<20100428165201.3d7d6b4a@griffin.suse.cz>	<20100428162056.GA2846@Krystal> <20100428185550.4406319c@logostar.upir.cz>
In-Reply-To: <20100428185550.4406319c@logostar.upir.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Apr 2010 17:24:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 06:55 PM, Jiri Benc wrote:
> On Wed, 28 Apr 2010 12:20:56 -0400, Mathieu Desnoyers wrote:
>> Can you try reverting commit c8d52465f95c4187871f8e65666c07806ca06d41 and see if
>> it helps ?
> 
> It doesn't. The produced code is identical.
> 
>> If you have other compiler versions handy, that would also be helpful to see if
>> the problem is specific to the gcc version you are using.
> 
> Tried 4.5.0, the same problem (at least looking at the produced assembler
> code, I haven't booted the kernel, but it looks very similar to 4.3.3).

I wrote on the bugzilla but this is not a compiler bug but the -stable
patch shouldn't have been applied only to 2.6.33.  Not 2.6.32.  This
is because till 2.6.32, ia64 hadn't been converted to dynamic percpu
allocator, so its static and dynamic percpu areas were separate and
the per_cpu_ptr() wouldn't do the offsetting the module code expects
there.  So, please revert the patch from 2.6.32.

Thanks.

-- 
tejun
