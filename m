Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1GKMRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:17:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab1GKMRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:17:39 -0400
Message-ID: <4E1AE9E2.2000603@suse.cz>
Date: Mon, 11 Jul 2011 14:17:38 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?VsOtY3RvciBNYW51ZWwgSsOhcXVleiBMZWFs?= 
	<vjaquez@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jianbin Kang <kjbmail@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: incremental tags updating with GNU GLOBAL
References: <1310379990-4367-1-git-send-email-vjaquez@igalia.com>
In-Reply-To: <1310379990-4367-1-git-send-email-vjaquez@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.7.2011 12:26, Víctor Manuel Jáquez Leal wrote:
> Instead of generating the tag database each time the target is ran, is better
> just update incrementally the database. It will expend less time.
>
> Signed-off-by: Víctor Manuel Jáquez Leal<vjaquez@igalia.com>
> ---
>   scripts/tags.sh |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 75c5d24..6a2fedc 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -116,7 +116,11 @@ docscope()
>
>   dogtags()
>   {
> -	all_sources | gtags -f -
> +	if global -p; then
> +		global -u
> +	else
> +		all_sources | gtags -f -
> +	fi

Will this handle new source files properly?

Michal
