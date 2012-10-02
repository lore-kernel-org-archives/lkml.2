Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2JBPyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:54:19 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42723 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2JBPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:54:18 -0400
Date: Tue, 2 Oct 2012 17:54:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf tools: Check existence of
 _get_comp_words_by_ref when bash completing
Message-ID: <20121002155358.GD10605@somewhere>
References: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
 <1349191294-6926-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349191294-6926-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 12:21:32AM +0900, Namhyung Kim wrote:
> The '_get_comp_words_by_ref' function is available from the bash
> completion v1.2 so that earlier version emits following warning:
> 
>   $ perf re<TAB>_get_comp_words_by_ref: command not found
> 
> Use older '_get_cword' method when the above function doesn't exist.

May be only use _get_cword then, if it works everywhere?

> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/bash_completion |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
> index 1958fa539d0f..3d48cee1b5e5 100644
> --- a/tools/perf/bash_completion
> +++ b/tools/perf/bash_completion
> @@ -1,12 +1,23 @@
>  # perf completion
>  
> +function_exists()
> +{
> +	declare -F $1 > /dev/null
> +	return $?
> +}
> +
>  have perf &&
>  _perf()
>  {
> -	local cur cmd
> +	local cur prev cmd
>  
>  	COMPREPLY=()
> -	_get_comp_words_by_ref cur prev
> +	if function_exists _get_comp_words_by_ref; then
> +		_get_comp_words_by_ref cur prev
> +	else
> +		cur=$(_get_cword)
> +		prev=${COMP_WORDS[COMP_CWORD-1]}
> +	fi
>  
>  	cmd=${COMP_WORDS[0]}
>  
> -- 
> 1.7.9.2
> 
