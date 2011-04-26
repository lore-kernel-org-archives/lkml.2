Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1DZK6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:58:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:40889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1DZK6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:58:17 -0400
Subject: Re: [PATCH 02/18] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
In-Reply-To: <1303576100-425-3-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
	 <1303576100-425-3-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 12:57:50 +0200
Message-ID: <1303815470.20212.260.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-23 at 18:28 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add a barebones implementation for registering persistent events with
> perf. For that, we don't destroy the buffers when they're unmapped and
> we map them read-only so that multiple agents can access them.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  include/linux/perf_event.h |   22 ++++++++++++++++-
>  kernel/events/Makefile     |    2 +-
>  kernel/events/core.c       |   30 ++++++++++++++++++----
>  kernel/events/persistent.c |   56 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 102 insertions(+), 8 deletions(-)
>  create mode 100644 kernel/events/persistent.c
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index ee9f1e7..37bfae1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -216,8 +216,9 @@ struct perf_event_attr {
>                                 precise_ip     :  2, /* skid constraint       */
>                                 mmap_data      :  1, /* non-exec mmap data    */
>                                 sample_id_all  :  1, /* sample_type all events */
> +                               persistent     :  1, /* event always on */

But how will you find it again?

Persistent yells filesystem to me, and while we didn't use relayfs for
various reasons, I think we do need something like it at the current
stage.


