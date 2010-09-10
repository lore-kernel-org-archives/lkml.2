Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0IJPVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:21:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40545 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751325Ab0IJPVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:21:15 -0400
Date: Fri, 10 Sep 2010 11:21:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM / Wakeup: Introduce wakeup source objects and
 event statistics (was: Re: Wakeup-events implementation)
In-Reply-To: <201009080151.43047.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1009101119060.1651-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Rafael J. Wysocki wrote:

> +struct wakeup_source *wakeup_source_create(const char *name)
> +{
> +	struct wakeup_source *ws;
> +
> +	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
> +	if (!ws)
> +		return NULL;
> +
> +	if (name) {
> +		int len = strlen(name);
> +		char *s = kzalloc(len + 1, GFP_KERNEL);
> +		if (s) {
> +			strncpy(s, name, len);
> +			ws->name = s;
> +		}
> +	}
> +
> +	return ws;
> +}

Forget what I wrote earlier; it was stupid.  Just use kstrdup.

Alan Stern

