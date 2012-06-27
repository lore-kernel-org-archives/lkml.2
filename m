Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2F0MkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:40:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2F0MkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:40:15 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=SVBeI296zcEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=_w-MO9lUEIP7HSUNWOEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340800812.16702.3.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/7] tracing/function: Introduce persistent trace option
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Wed, 27 Jun 2012 08:40:12 -0400
In-Reply-To: <1340753009-12483-4-git-send-email-anton.vorontsov@linaro.org>
References: <20120626232210.GA11549@lizard>
	 <1340753009-12483-4-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 16:23 -0700, Anton Vorontsov wrote:
>  
> @@ -219,6 +232,8 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
>  
>  		return 0;
>  	}
> +	if (bit == TRACE_FUNC_OPT_PSTORE)
> +		return 0;

Perhaps this should be a switch() statement, or at least put a
 } else if () {

As it can't be bit == TRACE_FUNC_OPT_STACK and bit ==
TRACE_FUNC_OPT_PSTORE.

-- Steve

>  
>  	return -EINVAL;
>  }


