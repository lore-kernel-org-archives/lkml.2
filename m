Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0J0LWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:22:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60519 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0J0LW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:22:28 -0400
Date: Wed, 27 Oct 2010 04:22:08 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Dan Carpenter <error27@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] configfs: documentation: remove unneeded check
Message-ID: <20101027112207.GA17439@mail.oracle.com>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20101027100735.GE6062@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027100735.GE6062@bicker>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 12:07:35PM +0200, Dan Carpenter wrote:
> If "p" is NULL then it will cause an oops when we pass it to
> simple_strtoul().  In this case "p" can not be NULL so I removed the
> check and cleaned up the rest of the if condition as well.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
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
> +	if (*p != '\0' && *p != '\n')
>  		return -EINVAL;

	If you're going to prefer "*p != '\0'" to "*p" as a test, I'd
like you to include parens: "if ((*p != '\0') && (*p != '\n'))"  While
the order of precedence is correct in your change, it makes folks have
to stop and think about order of precedence in the first place.

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
