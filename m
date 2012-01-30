Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2A3NwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:52:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2A3NwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:52:23 -0500
Date: Mon, 30 Jan 2012 14:46:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/3] staging: android: lowmemorykiller: Drop
	tasklist_lock usage
Message-ID: <20120130134601.GB14110@redhat.com>
References: <20120130011348.GC30274@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130011348.GC30274@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Anton Vorontsov wrote:
>
> @@ -132,8 +134,8 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>  	}
>  	selected_oom_adj = min_adj;
>
> -	read_lock(&tasklist_lock);
> -	for_each_process(p) {
> +	for_each_tgid(ns, iter) {

This makes force_sig() below unsafe, it can race with the exiting task.

Oleg.

