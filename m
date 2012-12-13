Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2LMNfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:35:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab2LMNfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:35:00 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_aGYK8jRc_AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SI-C17Dh1R0A:10 a=cFc9ES33HgeE0Hcm5gAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355405698.17101.373.camel@gandalf.local.home>
Subject: Re: [BUG] ftrace: available_filter_functions empty after unloading
 module
From: Steven Rostedt <rostedt@goodmis.org>
To: Piotr Haber <phaber@broadcom.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 13 Dec 2012 08:34:58 -0500
In-Reply-To: <50C5CB74.10008@broadcom.com>
References: <50C0B236.4090200@broadcom.com>
	 <1354817428.17101.10.camel@gandalf.local.home>
	 <50C1A3A3.8030107@broadcom.com>
	 <1354888679.17101.36.camel@gandalf.local.home>
	 <50C5CB74.10008@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 12:45 +0100, Piotr Haber wrote:

> > So you unloaded a module that you were tracing, correct? Hmm, the
> > warning that you hit was an accounting error. The accounting of what
> > functions are traced and what isn't. For some reason it tried to disable
> > a function that wasn't being traced.
> Yes, it happens when i unload a module that i traced before
> 
> > Can you easily reproduce this? If so, can you give my your .config and
> > the steps you used to trigger it.
> Not 100% but it happens often enough to be annoying
> Attached is the config
> As for reproduction, i load the brcmsmac module, add all it symbols to
> set_ftrace_filter, associate with AP and unload the module
> nothing fancy, i use 'function' tracer

Thanks, I'll see if I can reproduce it.

> 
> BTW.
> is it a feature that when there is a traceon trigger added on a function
> from module (like: echo 'brcms_free:traceon' > set_ftrace_filter) after
> module unloading it is not removed?
> just function name gets changed to symbol address

Um, ah, yyyeah! Yeah, yeah, feature. Yep that's a feature alright.

But I think it may be deprecated in the near future.

-- Steve


