Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1LKUsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:48:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1LKUsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:48:05 -0500
Message-ID: <4EE51709.1030305@suse.cz>
Date: Sun, 11 Dec 2011 21:48:09 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Gregory.Dietsche@cuw.edu
Cc: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [RESEND 3/3] coccicheck: add parallel execution
References: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu> <1320545653-28249-4-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1320545653-28249-4-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.11.2011 03:14, Gregory.Dietsche@cuw.edu wrote:
> +		coccinelle $f>/tmp/cocci_parallel_$$_$PARALLEL_ID 2>&1 &

This opens a symlink race.

And this whole parallel execution should be done by make. Just have a
generic rule for getting result from a single check, make the default
target depend on the list of the wanted results and concatenate the
results there. make -j will then take of parallelizing it.

Michal
