Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1K1Q6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:58:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53132 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1K1Q6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:58:53 -0500
Message-ID: <4ED3BDC6.2080104@gmail.com>
Date: Mon, 28 Nov 2011 09:58:46 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf tool: reset use_browser when compiled without NEWT
References: <1321913788-2867-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1321913788-2867-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

didn't see this one in your queue or a response. Do you agree this is
needed?

On 11/21/2011 03:16 PM, David Ahern wrote:
> e.g.,  when using
>   make NO_NEWT=yes ...
> or if newt-devel is not installed
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/cache.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
> index fc5e5a0..9d7612a 100644
> --- a/tools/perf/util/cache.h
> +++ b/tools/perf/util/cache.h
> @@ -36,6 +36,7 @@ extern int use_browser;
>  #ifdef NO_NEWT_SUPPORT
>  static inline void setup_browser(bool fallback_to_pager)
>  {
> +	use_browser = 0;
>  	if (fallback_to_pager)
>  		setup_pager();
>  }
