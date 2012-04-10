Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab2DJRgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:36:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab2DJRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:19 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=HzZ96Zh2etQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=n1J9tnSpHZsLmxeKSaQA:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334079376.23924.220.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/7] trace-cmd: Add NO_PYTHON option for Makefile
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 10 Apr 2012 13:36:16 -0400
In-Reply-To: <1333940074-19052-2-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
	 <1333940074-19052-2-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 11:54 +0900, Namhyung Kim wrote:
> If someone do not want to build python plugins, [s]he can
> define the option to disable python support:
> 
>   $ make NO_PYTHON=1

Thanks, I should also add a way to check if this will compile, or if it
fails to just print a message to build with this.

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  Makefile |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index edf3402..54dbba4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -76,6 +76,7 @@ ifndef VERBOSE
>    VERBOSE = 0
>  endif
>  
> +ifndef NO_PYTHON
>  PYTHON		:= ctracecmd.so
>  PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
>  
> @@ -86,6 +87,7 @@ ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
>  	PYTHON_SO_INSTALL := ctracecmd.install
>  	PYTHON_PY_INSTALL := event-viewer.install tracecmd.install tracecmdgui.install
>  endif
> +endif # NO_PYTHON
>  
>  # $(call test-build, snippet, ret) -> ret if snippet compiles
>  #                                  -> empty otherwise


