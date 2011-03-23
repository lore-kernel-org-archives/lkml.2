Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab1CWNns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:43:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1CWNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:43:46 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=sMsm3GrMBcUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=918aUZcbzx1wHlJbzs4A:9 a=kxFhmkfcuKL_P4lxmfWV1OV8DyoA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=WlBySCTHFFXIsE0r:21 a=PyRf320O3UyTNE4z:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RESEND 1/2] vsprintf: introduce %pT format specifier
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1300886997-30781-1-git-send-email-namhyung@gmail.com>
References: <20110323131213.GA25467@elte.hu>
	 <1300886997-30781-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Mar 2011 09:43:44 -0400
Message-ID: <1300887824.14261.130.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 22:29 +0900, Namhyung Kim wrote:
> The %pT format specifier is for stack backtrace. Its handler
> sprint_trace() does symbol lookup using (address-1) to ensure
> the address will not point outside of the function.
> 
> If there is a tail-call to the function marked "noreturn",
> gcc optimized out the code after the call then causes saved
> return address points outside of the function (i.e. the start
> of the next function), so pollutes call trace somewhat.
> This patch will fix it.
> 
> before:
> [   18.345923] Call Trace:
> [   18.346001]  [<ffffffff812a8502>] panic+0x8c/0x18d
> [   18.346257]  [<ffffffffa000012a>] deep01+0x0/0x38 [test_panic]  <--- bad
> [   18.346347]  [<ffffffff81104666>] proc_file_write+0x73/0x8d
> [   18.346432]  [<ffffffff811000b3>] proc_reg_write+0x8d/0xac
> [   18.346516]  [<ffffffff810c7d32>] vfs_write+0xa1/0xc5
> [   18.346603]  [<ffffffff810c7e0f>] sys_write+0x45/0x6c
> [   18.346801]  [<ffffffff8f02943b>] system_call_fastpath+0x16/0x1b
> 
> after:
> [   22.224483] Call Trace:
> [   22.224569]  [<ffffffff812bce69>] panic+0x8c/0x18d
> [   22.224848]  [<ffffffffa000012a>] panic_write+0x20/0x20 [test_panic]  <--- ok
> [   22.224979]  [<ffffffff81115fab>] proc_file_write+0x73/0x8d
> [   22.225089]  [<ffffffff81111a5f>] proc_reg_write+0x8d/0xac
> [   22.225199]  [<ffffffff810d90ee>] vfs_write+0xa1/0xc5
> [   22.225304]  [<ffffffff810d91cb>] sys_write+0x45/0x6c
> [   22.225408]  [<ffffffff812c07fb>] system_call_fastpath+0x16/0x1b

Nice

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


