Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2HQNzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:55:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2HQNzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:55:18 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LtHv6dTpUIwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=LKy4QqaoLnIA:10 a=meVymXHHAAAA:8 a=0RgcGhzwGWWYyDXlZZ0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345211714.3708.24.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 1/1] trace: Move trace event enable from fs_initcall
 to early_initcall
From: Steven Rostedt <rostedt@goodmis.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        tim.bird@am.sony.com, lizefan@huawei.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Fri, 17 Aug 2012 09:55:14 -0400
In-Reply-To: <CALF0-+WVoJ2NTPm7xZc0rr8-ZZ6an1BsN0SLtJvxzFd3CxA6bA@mail.gmail.com>
References: <1345043907-18299-1-git-send-email-elezegarcia@gmail.com>
	 <1345151883.3708.7.camel@gandalf.local.home>
	 <CALF0-+WVoJ2NTPm7xZc0rr8-ZZ6an1BsN0SLtJvxzFd3CxA6bA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 08:01 -0300, Ezequiel Garcia wrote:

> Regarding the 'complete solution': to be able to capture events from
> the very beggining...
> Have you thought about this?
> Could you give me a hint on how could I implement it?

How far in the "beginning"? Before memory is set up? I wouldn't do that.
I have in the past (set up before memory was finished being
initialized), but things have changed since then.

One thing that we could do for those that want really early tracing, is
to add a config option to add a static temporary ring buffer, that gets
copied into the default ring buffer after memory is set up. That may be
the easiest way.

Once memory is set up, the ring buffer can be allocated and events can
be traced, but the ring buffer needs to be set up first. All it would
take is some calls in init/main.c start_kernel() to the initialization.

-- Steve


