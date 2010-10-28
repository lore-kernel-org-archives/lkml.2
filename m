Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0J1L4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:56:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17983 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0J1L43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:56:29 -0400
Date: Thu, 28 Oct 2010 04:55:32 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Dan Carpenter <error27@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] configfs: documentation: remove unneeded check
Message-ID: <20101028115531.GG11937@mail.oracle.com>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20101027100735.GE6062@bicker>
 <20101027112207.GA17439@mail.oracle.com>
 <20101027145031.GG6062@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027145031.GG6062@bicker>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 04:50:31PM +0200, Dan Carpenter wrote:
> If "p" is NULL then it will cause an oops when we pass it to
> simple_strtoul().  In this case "p" can not be NULL so I removed the
> check.  I also changed the check a little to make it more explicit that
> we are testing whether p points to the NUL char.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Joel Becker <joel.becker@oracle.com>

> ---
> V2: Added some parenthesis to make the precedence more clear.
> 
> diff --git a/Documentation/filesystems/configfs/configfs_example_explicit.c b/Documentation/filesystems/configfs/configfs_example_explicit.c
> index d428cc9..63ff248 100644
> --- a/Documentation/filesystems/configfs/configfs_example_explicit.c
> +++ b/Documentation/filesystems/configfs/configfs_example_explicit.c
> @@ -89,7 +89,7 @@ static ssize_t childless_storeme_write(struct childless *childless,
>  	char *p = (char *) page;
>  
>  	tmp = simple_strtoul(p, &p, 10);
> -	if (!p || (*p && (*p != '\n')))
> +	if ((*p != '\0') && (*p != '\n'))
>  		return -EINVAL;
>  
>  	if (tmp > INT_MAX)
> 

-- 

"Sometimes I think the surest sign intelligent
 life exists elsewhere in the universe is that
 none of it has tried to contact us."
                                -Calvin & Hobbes

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
