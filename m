Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2EXK54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:57:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44263 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2EXK5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:57:55 -0400
Subject: Re: [PATCH 05/16] perf: Add attribute to filter out user callchains
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <1337801535-12865-6-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 12:57:48 +0200
Message-ID: <1337857068.9783.113.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> Add the new exclude_user_callchain attribute to filter out
> frame pointer based user callchains.
> 
> This is something we want to select when we use the dwarf cfi
> callchain mode, because frame pointer based user callchains are
> useless in this mode.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/perf_event.h |    4 +++-
>  kernel/events/callchain.c  |    4 ++--
>  kernel/events/core.c       |    3 ++-
>  kernel/events/internal.h   |    3 ++-
>  4 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index dcdc97e..df6ba37 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -275,7 +275,9 @@ struct perf_event_attr {
>  				exclude_host   :  1, /* don't count in host   */
>  				exclude_guest  :  1, /* don't count in guest  */
>  
> -				__reserved_1   : 43;
> +				exclude_user_callchain : 1, /* only record kernel callchains */

*sigh* I guess if we're going to do this we might as well do a complete
option set and also allow excluding kernel and possible hv if anybody
actually implemented that.

