Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2DXAzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:55:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab2DXAzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:55:16 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=X6OtPzvZJdgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=sozttTNsAAAA:8 a=6lNpguriyQWMJO3pV5wA:9 a=PUjeQqilurYA:10 a=x2szoZtqnggA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335228915.28106.129.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2] ktest.pl: Fix combined usage of BISECT_REVERSE and
 BISECT_SKIP
From: Steven Rostedt <rostedt@goodmis.org>
To: Russ Dill <Russ.Dill@ti.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 23 Apr 2012 20:55:15 -0400
In-Reply-To: <1335222909-14191-1-git-send-email-Russ.Dill@ti.com>
References: <1335222539-31546-1-git-send-email-Russ.Dill@ti.com>
	 <1335222909-14191-1-git-send-email-Russ.Dill@ti.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 16:15 -0700, Russ Dill wrote:
> When BISECT_REVERSE and BISECT_SKIP are used together with boot or test testing,
> build failures are treated as boot or test failures and 'git bisect bad' is executed instead
> of 'git bisect skip'. This is because the $ret value of -1 is treated as a build failure, but
> the $reverse_bisect logic does not properly handle this.
> 
> Simple fix, don't invert $ret if it is -1.
> 
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
> ---
>  tools/testing/ktest/ktest.pl |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index 95d6a6f..5221b00 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -2192,7 +2192,7 @@ sub run_bisect {
>      }
>  
>      # Are we looking for where it worked, not failed?
> -    if ($reverse_bisect) {
> +    if ($reverse_bisect && $ret != -1) {

Thanks! But can you resend with the following change:

	... && $ret >= 0) {

Just incase we have $ret be another negative number for something else.

-- Steve

>  	$ret = !$ret;
>      }
>  


