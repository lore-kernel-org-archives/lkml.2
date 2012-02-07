Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2BGKnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:43:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46339 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2BGKnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:43:14 -0500
Message-ID: <4F31003E.2090901@openvz.org>
Date: Tue, 07 Feb 2012 14:43:10 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX] mm: fix find_get_page() for shmem exceptional
 entries
References: <20120207103121.28345.28611.stgit@zurg>
In-Reply-To: <20120207103121.28345.28611.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug was added in commit v3.0-7291-g8079b1c (mm: clarify the radix_tree exceptional cases)
So, v3.1 and v3.2 affected.

Konstantin Khlebnikov wrote:
> It should return NULL, otherwise the caller will be very surprised.
>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> ---
>   mm/filemap.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 518223b..ca98cb5 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -693,6 +693,7 @@ repeat:
>   			 * here as an exceptional entry: so return it without
>   			 * attempting to raise page count.
>   			 */
> +			page = NULL;
>   			goto out;
>   		}
>   		if (!page_cache_get_speculative(page))
>

