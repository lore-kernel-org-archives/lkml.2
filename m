Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2DWS5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:57:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2622 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2DWS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:57:16 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=S_kVXmggQAAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=57SyGIRnAAAA:8 a=ScnmdKOFcl6ZJSR0lngA:9 a=E3bm7-VGjGFwII6SLDQA:7 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335207434.28106.117.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 10/11] parse-filter: Fix signature of create_arg_item()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 14:57:14 -0400
In-Reply-To: <1335157118-14658-11-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-11-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> The @type should be a type of enum event_type not enum
> filter_arg_type. This fixes following warning:
> 
>  $ make
>   COMPILE FPIC           parse-events.o
>   COMPILE FPIC           parse-filter.o
> /home/namhyung/project/trace-cmd/parse-filter.c: In function ‘create_arg_item’:
> /home/namhyung/project/trace-cmd/parse-filter.c:343:9: warning: comparison between ‘enum filter_arg_type’ and ‘enum event_type’ [-Wenum-compare]
> /home/namhyung/project/trace-cmd/parse-filter.c:339:2: warning: case value ‘8’ not in enumerated type ‘enum filter_arg_type’ [-Wswitch]
>   BUILD STATIC LIB       libparsevent.a
>   BUILD STATIC LIB       libtracecmd.a
>   BUILD                  trace-cmd
> /usr/bin/make -C /home/namhyung/project/trace-cmd/Documentation all
> make[1]: Nothing to be done for `all'.
> Note: to build the gui, type "make gui"

Applied thanks!

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-filter.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/parse-filter.c b/parse-filter.c
> index 0e6c0b1..fa6e6a2 100644
> --- a/parse-filter.c
> +++ b/parse-filter.c
> @@ -325,9 +325,8 @@ static void free_events(struct event_list *events)
>  }
>  
>  static struct filter_arg *
> -create_arg_item(struct event_format *event,
> -		const char *token, enum filter_arg_type type,
> -		char **error_str)
> +create_arg_item(struct event_format *event, const char *token,
> +		enum event_type type, char **error_str)
>  {
>  	struct format_field *field;
>  	struct filter_arg *arg;


