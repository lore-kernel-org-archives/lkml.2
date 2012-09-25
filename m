Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2IYPof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:44:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49759 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab2IYPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:44:34 -0400
Message-ID: <5061D15F.6070408@wwwdotorg.org>
Date: Tue, 25 Sep 2012 09:44:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Markus Mayer <mmayer@broadcom.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix segfault in dtc when empty input file is given.
References: <20120914222304.GA2698@mmayer.net>
In-Reply-To: <20120914222304.GA2698@mmayer.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 04:23 PM, Markus Mayer wrote:
> Prior to this change, an empty input file would cause a segfault, because
> yylloc had never been initialized. There was never any characters for the
> lexer to match, so YY_USER_ACTION was never executed before the parse error
> was detected.
> 
> When the parser printed the error message, it tried to include the name of
> the file, but the structure holding the file name (yylloc.file, referenced
> as pos->file) had never been initialized.

> diff --git a/scripts/dtc/treesource.c b/scripts/dtc/treesource.c

>  struct boot_info *dt_from_source(const char *fname)
>  {
> +	extern YYLTYPE yylloc;
> +
>  	the_boot_info = NULL;
>  	treesource_error = 0;
>  
>  	srcfile_push(fname);
>  	yyin = current_srcfile->f;
> +	/* Initialize yylloc->file to avoid segfault on empty input */
> +	srcpos_update(&yylloc, NULL, 0);

Wouldn't srcpos_update(&yyloc, fname, 0); be even more informative?

