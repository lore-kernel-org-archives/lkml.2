Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2BXOxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:53:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab2BXOx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:53:28 -0500
Date: Fri, 24 Feb 2012 09:53:24 -0500
From: Jason Baron <jbaron@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [patch] epoll: remove unneeded variable in reverse_path_check()
Message-ID: <20120224145323.GA2395@redhat.com>
References: <20120224113158.GA17641@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224113158.GA17641@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 02:31:58PM +0300, Dan Carpenter wrote:
> We never use the length variable.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index c636fc8..997a6d2 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1042,13 +1042,11 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
>   */
>  static int reverse_path_check(void)
>  {
> -	int length = 0;
>  	int error = 0;
>  	struct file *current_file;
>  
>  	/* let's call this for all tfiles */
>  	list_for_each_entry(current_file, &tfile_check_list, f_tfile_llink) {
> -		length++;
>  		path_count_init();
>  		error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
>  					reverse_path_check_proc, current_file,

Yes, I had that in there while testing, and should have removed it.

Acked-by: Jason Baron <jbaron@redhat.com>

Thanks,

-Jason
