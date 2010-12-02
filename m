Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0LBWlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:41:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36572 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0LBWlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dp6heIJ+lR+u4XSQ2zgeYGkY1gPpU8FqwFPgswqG4+PTfzYIJhVMzAabcXMaV7PFpE
         gBRcSpLh9TJEehwiEiRM/v0CEG0XQkXX9q7ZrTkLSTtm3j+LU60436qpX3dywv0ZOJ1W
         8JfzhsRqerabmUlzKJr0G6H7AUKYsJMdATFn8=
Date: Thu, 2 Dec 2010 23:41:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] perf: Prevent potential null dereference
Message-ID: <20101202224104.GA1639@nowhere>
References: <20101202222605.GA6471@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202222605.GA6471@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 01:26:05AM +0300, Cyrill Gorcunov wrote:
> In case if there is no memory we might hit null
> dereference on accessing calloc'ed data.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> 
> It seems exit right here is more convenient than passing error
> handling level up (which would have to exit anyway), thought
> if handling it "upper" is preferred -- just say a word.
> 
>  tools/perf/builtin-record.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6.git/tools/perf/builtin-record.c
> =====================================================================
> --- linux-2.6.git.orig/tools/perf/builtin-record.c
> +++ linux-2.6.git/tools/perf/builtin-record.c
> @@ -524,6 +524,10 @@ static void comm__construct(int argc, co
>  		return;
>  
>  	comm = calloc(1, size);
> +	if (!comm) {
> +		pr_err("Not enough memory to construct internal command line.\n");
> +		exit(-1);
> +	}
>  
>  	tmp = comm;
>  	for (i = 0; i < argc; i++) {


Good.

As a nit, not that it matters that much because we are very close to the starting code
anyway, but it would be better to propagate the error to the callers.

Thanks.
