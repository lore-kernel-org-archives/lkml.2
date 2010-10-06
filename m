Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab0JFEoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:44:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58000 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0JFEoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=gn9+X90D5T+yEY995Fz0y3kc8uTa5dN4hgIGJa8y8shLakbSWsP9IyBxiRD40Kvb5x
         pLULzDg0Zt1efBGmXiall9gHXOJ+NDyfABD8z9ZtXGpNzvtVhEo8YXHXZnsR7vPWdc4s
         9QqgcfflAOO4mnBHa2qIF6z6yahxsg4O7WhUE=
Date: Wed, 6 Oct 2010 06:44:00 +0200
From: Dan Carpenter <error27@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/28] Staging: comedi: kcomedilib: kcomedilib_main.c:
	Edit file so that checkpatch.pl has 0 errors and warnings
Message-ID: <20101006044400.GB5409@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
	abbotti@mev.co.uk, fmhess@users.sourceforge.net,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com> <1286326843-6170-10-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286326843-6170-10-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:00:25PM -0400, Tracey Dent wrote:
> @@ -50,7 +50,7 @@ struct comedi_device *comedi_open(const char *filename)
>  	if (strncmp(filename, "/dev/comedi", 11) != 0)
>  		return NULL;
>  
> -	minor = simple_strtoul(filename + 11, NULL, 0);
> +	minor = strict_strtoul(filename + 11, NULL, 0);
>  

No, this doesn't work.  strict_strtoul() only returns zero and -EINVAL.
It doesn't return the number.

GCC even warns about this change:
drivers/staging/comedi/kcomedilib/kcomedilib_main.c: In function ‘comedi_open’:
drivers/staging/comedi/kcomedilib/kcomedilib_main.c:53: warning:
passing argument 2 of ‘strict_strtoul’ makes integer from pointer without a cast

Please at least compile these before sending.  :(

>  	if (minor >= COMEDI_NUM_BOARD_MINORS)
>  		return NULL;

regards,
dan carpenter
