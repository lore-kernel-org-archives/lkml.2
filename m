Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0FCQdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:33:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31067 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0FCQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:33:18 -0400
Message-ID: <4C07D92A.4000806@oracle.com>
Date: Thu, 03 Jun 2010 09:32:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Michal Marek <mmarek@suse.cz>, Nobin Mathew <nobin.mathew@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] menuconfig: fix to center checklist correctly in
 a corner case
References: <4C0758B7.5070907@cn.fujitsu.com>
In-Reply-To: <4C0758B7.5070907@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C07D934.0222:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/10 00:24, Li Zefan wrote:
> Run:
> 	make ARCH=arm menuconfig
> 
> And then select "System Type" -> "ARM system type". The kconfig
> "choice" menu at this point looks empty.
> 
> It's because config ARCH_S3C2410 has a long prompt:
> 
> config ARCH_S3C2410
>         bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440, S3C2442, S3C2443, S3C2450"
> 	...
> 
> menuconfig centers the checklist according to this prompt without
> considering the width of the list, and then things get wrong.
> 
> Reported-by: Nobin Mathew <nobin.mathew@gmail.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> Please queue these 2 patches for 2.6.35.

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  scripts/kconfig/lxdialog/checklist.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
> index bcc6f19..c92a05a 100644
> --- a/scripts/kconfig/lxdialog/checklist.c
> +++ b/scripts/kconfig/lxdialog/checklist.c
> @@ -175,6 +175,7 @@ do_resize:
>  	check_x = 0;
>  	item_foreach()
>  		check_x = MAX(check_x, strlen(item_str()) + 4);
> +	check_x = MIN(check_x, list_width);
>  
>  	check_x = (list_width - check_x) / 2;
>  	item_x = check_x + 4;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
