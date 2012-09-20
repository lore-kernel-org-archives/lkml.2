Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2ITPzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:55:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab2ITPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:55:51 -0400
Date: Thu, 20 Sep 2012 17:55:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Engelthaler <engycz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Fix bug in end absolute address in drivers/mtd/devices/slram.c
In-Reply-To: <CAHODtZTFP=KJh1VmBvCcYLWD=M41vBnf_nyoEbvHKW1UzYx8dQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1209201754450.31786@twin.jikos.cz>
References: <CAHODtZTFP=KJh1VmBvCcYLWD=M41vBnf_nyoEbvHKW1UzYx8dQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Jiri Engelthaler wrote:

> Hello.
>   I found a bug in parsing end absolute address in
> drivers/mtd/devices/slram.c. There is checking for startaddress <
> endaddress and endaddress subtracted by startaddress before check. The
> bug is there from commit 3afd522de8d8ec446efe957b86e4f63e3dd8ce9d Mon,
> 19 Jan 2009 01:24:21 +0000
> 
> Here is the patch
> 
> Signed-off-by: Jiri Engelthaler <engycz@gmail.com>
> 
> --- linux-3.2.28/drivers/mtd/devices/slram.c	2012-08-19 19:15:38.000000000 +0200
> +++ linux-3.2.28.mod/drivers/mtd/devices/slram.c	2012-09-19
> 18:29:28.012740703 +0200
> @@ -266,7 +266,7 @@ static int parse_cmdline(char *devname,
> 
>  	if (*(szlength) != '+') {
>  		devlength = simple_strtoul(szlength, &buffer, 0);
> -		devlength = handle_unit(devlength, buffer) - devstart;
> +		devlength = handle_unit(devlength, buffer);
>  		if (devlength < devstart)
>  			goto err_out;

... adding the suspects to CC so that they are aware of this.

-- 
Jiri Kosina
SUSE Labs

