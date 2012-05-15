Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965882Ab2EOQnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:43:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40741 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2EOQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:43:05 -0400
Date: Tue, 15 May 2012 09:43:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 04/16] Fix ratelimit macro to compile in c99 mode
Message-ID: <20120515164300.GA20827@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <d7cfd6b70316efc3fe2ce575203d906a610e3670.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7cfd6b70316efc3fe2ce575203d906a610e3670.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:09:00PM -0400, Kent Overstreet wrote:
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  include/linux/ratelimit.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> index e11ccb4..9ad57d3 100644
> --- a/include/linux/ratelimit.h
> +++ b/include/linux/ratelimit.h
> @@ -20,7 +20,7 @@ struct ratelimit_state {
>  #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
>  									\
>  	struct ratelimit_state name = {					\
> -		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
> +		.lock		= __RAW_SPIN_LOCK_INITIALIZER(name.lock),\

NACK, kernel is not built in c99 mode and using anonymous struct in
struct initializers is an accepted convention.

Thanks.

-- 
tejun
