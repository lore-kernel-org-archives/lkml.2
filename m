Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1AaNbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:31:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab1AaNbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:31:11 -0500
Date: Mon, 31 Jan 2011 14:22:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, ebiederm@xmission.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        clg@fr.ibm.com
Subject: Re: [PATCH 2/4] pidns: Call pid_ns_prepare_proc from
	create_pid_namespace
Message-ID: <20110131132207.GA26995@redhat.com>
References: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr> <1296469525-30111-3-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296469525-30111-3-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Daniel Lezcano wrote:
>
> @@ -96,6 +97,9 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
>  	for (i = 1; i < PIDMAP_ENTRIES; i++)
>  		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
>
> +	if (pid_ns_prepare_proc(ns))
> +		goto out_free_map;
> +
>  	return ns;

This is not right, afaics. I already sent the similar patches, but
they were ignored ;)

Please see http://marc.info/?l=linux-kernel&m=127697484000334

If pid_ns_prepare_proc() fails we shouldn't blindly return ENOMEM
and, more importantly, we need put_pid_ns(parent_ns).

Oleg.

