Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2FRNoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:44:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2FRNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:44:17 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=j5yNOur2Y3MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=SQ4e0o_wACPdhw6DTBoA:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340027055.25903.88.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2 5/5] scripts/tags.sh: Teach [ce]tags about
 libtraceeevent error codes
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Michal Marek <mmarek@suse.cz>
Date: Mon, 18 Jun 2012 09:44:15 -0400
In-Reply-To: <1339987851-22491-5-git-send-email-namhyung@kernel.org>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
	 <1339987851-22491-5-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 11:50 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> As we use a macro trick to sync each error codes with its
> description string, teach [ce]tags to process them properly.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Link: http://lkml.kernel.org/n/tip-qt5fv4pzigr2nnl27ydimg4h@git.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  scripts/tags.sh |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index cf7b12fee573..cff8faad73d1 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -153,7 +153,8 @@ exuberant()
>  	--regex-c++='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
>  	--regex-c++='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/'	\
>  	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
> -	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
> +	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
> +	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
>  
>  	all_kconfigs | xargs $1 -a                              \
>  	--langdef=kconfig --language-force=kconfig              \
> @@ -195,7 +196,8 @@ emacs()
>  	--regex='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
>  	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
>  	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
> -	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
> +	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
> +	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
>  
>  	all_kconfigs | xargs $1 -a                              \
>  	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'


This works great if we run tags from the top level kernel tree, but we
need to also add this in the perf directory as well.

I'll ack this patch for now, and we can fix up perf later. I think there
should be an easy way to get perf to use the tags.sh script from the
scripts directory.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


