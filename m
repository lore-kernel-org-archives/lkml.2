Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2INBuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 21:50:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2INBt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 21:49:58 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ot5UZnNMOZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ggEItVuWx8YA:10 a=proj722jCw06pSGlkGIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347587395.10751.88.camel@gandalf.local.home>
Subject: Re: [RFC] add "enable" to the kconfig language
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Sep 2012 21:49:55 -0400
In-Reply-To: <20120914101414.1e24b28d2cfa8fc030952a58@canb.auug.org.au>
References: <20120914101414.1e24b28d2cfa8fc030952a58@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 10:14 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> I have noticed that we use the following paradigm quite a bit theses days:
> 
> config <something
> 	select HAVE_<config1>
> 
> config <config1>
> 	depends on HAVE_<config1>
> 
> or similar
> 
> I was wondering if it would make sense to replace this with:
> 
> config <something
> 	enable <config1>
> 
> config <config1>
> 	depends on enabled
> 
> The advantage of this is that we would not have all the HAVE_ config
> names in our .config files and the generated include files.  Of course,
> if config1 does not depend on "enabled", then the "enable <config1>"
> would have no effect (we may want to warn about this).
> 
> Comments?

I always hated those HAVE_* configs, especially because they were always
a source of confusion when asking someone if something is enabled...

Them: "The function tracer doesn't work, I don't see any debugfs files"

me: "Do you have FUNCTION_TRACER enabled?"

Them: "Yes, I checked"

me: "You have *FUNCTION_TRACER* not *HAVE_FUNCTION_TRACER*?"

Them: "Oh, no I just have HAVE_FUNCTION_TRACER"

BAH!

If you can make 'enable' work, I would definitely Ack converting over to
it.

-- Steve


