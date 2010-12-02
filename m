Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0LBPZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 10:25:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:55471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab0LBPZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 10:25:35 -0500
Message-ID: <4CF7BA6D.60002@suse.cz>
Date: Thu, 02 Dec 2010 16:25:33 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bug in scripts/package/mkspec?
References: <AANLkTin01j5oTUdh6fAgs--Gi46BZOWZCdypUPd8uhm4@mail.gmail.com>
In-Reply-To: <AANLkTin01j5oTUdh6fAgs--Gi46BZOWZCdypUPd8uhm4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.11.2010 19:13, Patrick LeBoutillier wrote:
> Hi all,
> 
> I've been building RPMs for the Linux kernel for a while now and only
> recently noticed that the RPM Release field is always set to 1.
> After a bit of searching I found the offending line in
> scripts/package/mkspec. Here is a patch that worked for me, but
> perhaps this
> could be fixed in better way by someone knowledgeable of the kernel
> build process...:
> 
> 
> --- ./mkspec.next       2010-11-18 13:08:56.000000000 -0500
> +++ mkspec      2010-11-18 13:10:13.000000000 -0500
> @@ -29,7 +29,7 @@
>  echo "Version: $__KERNELRELEASE"
>  # we need to determine the NEXT version number so that uname and
>  # rpm -q will agree
> -echo "Release: `. $srctree/scripts/mkversion`"
> +echo "Release: `cd $srctree && ./scripts/mkversion`"

This doesn't look correct to me, the script reads the .version file
which is in the build directory, not in the source dir. Can you post a
step-by-step reproducer for your bug?

Thanks,
Michal
