Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1ADQij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:38:39 -0500
Received: from fieldses.org ([174.143.236.118]:33887 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1ADQii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:38:38 -0500
Date: Tue, 4 Jan 2011 11:38:36 -0500
To: Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        joe@perches.com
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
Message-ID: <20110104163836.GA30317@fieldses.org>
References: <20110104055900.GA5062@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104055900.GA5062@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 08:59:00AM +0300, Dan Carpenter wrote:
> This patch makes checkpatch.pl complain if you break up conditions in
> the wrong way.
> 
> Wrong:
> 	if ((really_long_condition)
> 		&& (second_condition)) { ...
> Right:
> 	if ((really_long_condition) &&
> 		(second_condition)) { ...

As far as I can tell, the convention in mathematical typesetting is to
put operators on the left, not the right.  When the conditions are short
of there are more lines, that allows you to left-align on the repeated
operator.

--b.

> 
> If you do it in the wrong way the message is:  "put the && or || at the
> end of the previous line"
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index e3c7fc0..0a813db 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1509,6 +1509,11 @@ sub process {
>  			WARN("please, no space before tabs\n" . $herevet);
>  		}
>  
> +# check for && or || at the start of a line
> +		if ($rawline =~ /^\+\W+(&&|\|\|)/) {
> +			WARN("put the && or || at the end of the previous line\n" . $herecurr);
> +		}
> +
>  # check for spaces at the beginning of a line.
>  # Exceptions:
>  #  1) within comments
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
