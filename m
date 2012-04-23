Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2DWSsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:48:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2DWSsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:48:39 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=24inrg7083MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=dBVi48o1GMgtafVmEHQA:9 a=6mkLn369IvTL7mH9F6UA:7 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335206917.28106.116.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 09/11] parse-filter: Check result of malloc() during
 reading token
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 14:48:37 -0400
In-Reply-To: <1335157118-14658-10-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-10-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> The malloc can fail so the return value should be checked.
> For now, just use malloc_or_die().

Applied, thanks!

Although we will be getting rid of the 'die' feature. But at least this
marks a location that we need to track.

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-filter.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/parse-filter.c b/parse-filter.c
> index bc62f1f..0e6c0b1 100644
> --- a/parse-filter.c
> +++ b/parse-filter.c
> @@ -96,7 +96,7 @@ static enum event_type read_token(char **tok)
>  	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
>  	    pevent_peek_char() == '~') {
>  		/* append it */
> -		*tok = malloc(3);
> +		*tok = malloc_or_die(3);
>  		sprintf(*tok, "%c%c", *token, '~');
>  		free_token(token);
>  		/* Now remove the '~' from the buffer */


