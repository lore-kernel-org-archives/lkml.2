Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab2LUDDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:03:12 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:40645 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2LUDDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:03:05 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 22:03:05 EST
Message-ID: <50D3CFBF.50902@gmail.com>
Date: Thu, 20 Dec 2012 21:55:59 -0500
From: Daniel Hazelton <dshadowwolf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Paton J. Lewis" <palewis@adobe.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: stop comparing pointers with 0 in self-test app
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-6-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1356030701-16284-6-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see anything obviously wrong here...
Reviewed-By: Daniel Hazelton <dshadowwolf@gmail.com>

On 12/20/2012 02:11 PM, Sasha Levin wrote:
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   tools/testing/selftests/epoll/test_epoll.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/epoll/test_epoll.c b/tools/testing/selftests/epoll/test_epoll.c
> index 4a14a7f..1034ed4 100644
> --- a/tools/testing/selftests/epoll/test_epoll.c
> +++ b/tools/testing/selftests/epoll/test_epoll.c
> @@ -199,8 +199,8 @@ int main(int argc, char **argv)
>
>   	epoll_items = malloc(n_epoll_items * sizeof(struct epoll_item_private));
>
> -	if (epoll_set < 0 || epoll_items == 0 || write_thread_data.fds == 0 ||
> -		read_thread_data == 0 || read_threads == 0)
> +	if (epoll_set < 0 || !epoll_items || write_thread_data.fds == NULL ||
> +		!read_thread_data || !read_threads)
>   		goto error;
>
>   	if (sysconf(_SC_NPROCESSORS_ONLN) < 2) {
>

