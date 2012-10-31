Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895Ab2JaV4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:56:53 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4472 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760596Ab2JaV4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:56:51 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <50919E88.8060900@broadcom.com>
Date: Wed, 31 Oct 2012 22:56:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028
 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64: undefined symbol 'mcount' in 3.7-rc1
References: <507F13DE.2010601@broadcom.com>
 <1351709060.4004.91.camel@gandalf.local.home>
In-Reply-To: <1351709060.4004.91.camel@gandalf.local.home>
X-WSS-ID: 7C8F41AE3QC2269569-01-01
Content-Type: text/plain;
 charset=iso-8859-15;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 07:44 PM, Steven Rostedt wrote:
> On Wed, 2012-10-17 at 22:23 +0200, Arend van Spriel wrote:
>> Hi Steven,
>>
>> I have nightly test machines upgraded to 3.7-rc1 and on the 64-bit
>> platform I get MODPOST warning on 'mcount'.
>>
>> It is conditionally exported in x8664_ksyms_64.c:
>> #ifdef CONFIG_FUNCTION_TRACER
>> /* mcount is defined in assembly */
>> EXPORT_SYMBOL(mcount);
>> #endif
>>
>> #ifdef CONFIG_FUNCTION_TRACER
>> #ifdef CC_USING_FENTRY
>> # define MCOUNT_ADDR           ((long)(__fentry__))
>> #else
>> # define MCOUNT_ADDR           ((long)(mcount))
>> #endif
>> #define MCOUNT_INSN_SIZE       5 /* sizeof mcount call */
>>
>> I have built the kernel on x86 machine with gcc 4.6.3 and the modules
>> are built during the test execution on test machine which has gcc 4.4.5.
>> Reading commit below
>>
>> commit d57c5d51a30152f3175d2344cb6395f08bf8ee0c
>> Author: Steven Rostedt <srostedt@redhat.com>
>> Date:   Wed Feb 9 13:32:18 2011 -0500
>>
>>       ftrace/x86: Add support for -mfentry to x86_64
>>
>> I suppose the gcc version mismatch is causing my problem. Is that a
>> correct assumption?
>
> Yes.
>
> gcc 4.6.0 added a new option to gcc called '-mfentry'. The kernel build
> checks to see if this option is supported and if so it will use it. What
> this option does (when added to -pg), will not do the mcount calling but
> instead call fentry. The two have different semantics and are not
> compatible. When you built your kernel, the build process detected that
> -mfentry is supported and used that.
>
> Now when you built your modules with gcc 4.4.5, -mfentry was not
> supported and it used the mcount feature instead. In general, it's not a
> good idea to use two different gcc's to build the kernel and modules.
>
> But if you really need to, then you should disable function tracing of
> your modules, where the -pg and -mfentry wont be used.
>
> -- Steve

Thanks Steve(n)

I just upgraded the test machine to have the same gcc as the machine 
building the kernels.

Gr. AvS

