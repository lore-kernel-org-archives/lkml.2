Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1ADG6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:58:53 -0500
Received: from mail.perches.com ([173.55.12.10]:2938 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1ADG6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:58:52 -0500
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20110104055900.GA5062@bicker>
References: <20110104055900.GA5062@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 22:58:50 -0800
Message-ID: <1294124330.6617.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 08:59 +0300, Dan Carpenter wrote:
> This patch makes checkpatch.pl complain if you break up conditions in
> the wrong way.
> 
> Wrong:
> 	if ((really_long_condition)
> 		&& (second_condition)) { ...
> Right:
> 	if ((really_long_condition) &&
> 		(second_condition)) { ...
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

This should be /^\+[ \t]*(&&|\|\|)/

> +			WARN("put the && or || at the end of the previous line\n" . $herecurr);

I've submitted something like this a couple of times and gotten
various objections but I think it's sensible.

https://lkml.org/lkml/2009/12/5/65
https://lkml.org/lkml/2010/7/11/92


