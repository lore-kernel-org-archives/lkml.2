Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2LCQjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:39:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab2LCQjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:39:43 -0500
Message-ID: <50BCD5CB.2030506@suse.cz>
Date: Mon, 03 Dec 2012 17:39:39 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scripts/tags.sh: Support compiled source
References: <1354551724-15089-1-git-send-email-js1304@gmail.com> <1354551724-15089-2-git-send-email-js1304@gmail.com>
In-Reply-To: <1354551724-15089-2-git-send-email-js1304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.12.2012 17:22, Joonsoo Kim wrote:
> We usually have interst in compiled files only,
> because they are strongly related to individual's work.
> Current tags.sh can't select compiled files, so support it.
> 
> We can use this functionality like below.
> "make cscope O=. SRCARCH=xxxx SUBARCH=compiled"

I like the idea, but please try to come up with a different syntax that
does not abuse SUBARCH.


> +all_compiled_sources()
> +{
> +	for i in $(all_sources); do
> +		if [[ $i =~ .*c$ || $i =~ .*S$ ]]; then
> +			j=${i/\.[cS]/\.o}

Please use 'case "$i" in ...' instead of the bash-specific [[ ... ]]
construct.

Michal
