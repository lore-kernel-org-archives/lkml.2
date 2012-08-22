Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2HVGyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:54:46 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44075 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2HVGyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:54:38 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-6c-5034822c1d25
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] tools lib traceevent: Modify header to work in C++ programs
References: <1345590800.5069.17.camel@gandalf.local.home>
Date: Wed, 22 Aug 2012 15:47:50 +0900
In-Reply-To: <1345590800.5069.17.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 21 Aug 2012 19:13:20 -0400")
Message-ID: <87boi3ifs9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve

On Tue, 21 Aug 2012 19:13:20 -0400, Steven Rostedt wrote:
> tools lib traceevent: Modify header to work in C++ programs
>
> Replace keyword "private" from event-parse.h to allow it to be
> used in C++ programs.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 5772ad8..c28713b 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -49,7 +49,7 @@ struct pevent_record {
>  	int			cpu;
>  	int			ref_count;
>  	int			locked;		/* Do not free, even if ref_count is zero */
> -	void			*private;
> +	void			*r_private;

This r_ (and p_) prefix make it inconsistent with others. How about
simply using 'priv' instead?

Thanks,
Namhyung


>  #if DEBUG_RECORD
>  	struct pevent_record	*prev;
>  	struct pevent_record	*next;
> @@ -106,7 +106,7 @@ struct plugin_option {
>  	char				*plugin_alias;
>  	char				*description;
>  	char				*value;
> -	void				*private;
> +	void				*p_private;
>  	int				set;
>  };
>  
