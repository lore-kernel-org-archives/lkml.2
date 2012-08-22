Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab2HVNhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:37:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31549 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab2HVNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:37:45 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RMExtYoXNVsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=QJxaPmtj2xwA:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=GB8cqOoQ4109WcGNhpwA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345642662.5069.28.camel@gandalf.local.home>
Subject: Re: [PATCH 1/5] trace-cmd: Use TRACE_DIR envrionment variable if
 defined
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 22 Aug 2012 09:37:42 -0400
In-Reply-To: <20120822084301.17293.90649.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
	 <20120822084301.17293.90649.stgit@ltc189.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 17:43 +0900, Yoshihiro YUNOMAE wrote:
> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Use TRACE_DIR environment variable for setting

TRACING_DIR would be better, as we are searching for /debug/tracing and
not /debug/trace. Perhaps DEBUG_TRACING_DIR would be even better as to
be less of a generic term.

-- Steve

> debugfs/tracing directory if defined. This is
> for controlling guest(or remote) ftrace.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> ---
> 
>  trace-util.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/trace-util.c b/trace-util.c
> index e128188..d5a3eb4 100644
> --- a/trace-util.c
> +++ b/trace-util.c
> @@ -311,6 +311,15 @@ char *tracecmd_find_tracing_dir(void)
>  	char type[100];
>  	FILE *fp;
>  	
> +	tracing_dir = getenv("TRACE_DIR");
> +	if (tracing_dir) {
> +		tracing_dir = strdup(tracing_dir);
> +		if (!tracing_dir)
> +			die("malloc");
> +		warning("Use environmental tracing directory: %s\n", tracing_dir);
> +		return tracing_dir;
> +	}
> +
>  	if ((fp = fopen("/proc/mounts","r")) == NULL) {
>  		warning("Can't open /proc/mounts for read");
>  		return NULL;
> 


