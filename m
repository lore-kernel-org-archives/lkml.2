Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab2IHA4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:56:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57702 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab2IHA4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:56:49 -0400
Date: Fri, 7 Sep 2012 17:56:42 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 04/12] perf diff: Refactor diff displacement possition
 info
Message-ID: <20120908005642.GE20401@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346946426-13496-5-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 06, 2012 at 05:46:58PM +0200, Jiri Olsa escreveu:
> @@ -150,6 +154,24 @@ static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
>  	return NULL;
>  }
>  
> +static void resort_evlist(struct perf_evlist *evlist, bool name)

For consistency, please use:

+static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)

> +{
> +	struct perf_evsel *evsel;
> +
> +	list_for_each_entry(evsel, &evlist->entries, node) {
> +		struct hists *hists = &evsel->hists;
> +
> +		hists__output_resort(hists);
> +
> +		/*
> +		 * The hists__name_resort only sets possition
> +		 * if name is false.
> +		 */
> +		if (name || ((!name) && show_displacement))
> +			hists__name_resort(hists, name);

- Arnaldo
