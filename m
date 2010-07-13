Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0GMMgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 08:36:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:55168 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0GMMgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 08:36:53 -0400
Message-ID: <4C3C5DE3.7030306@suse.cz>
Date: Tue, 13 Jul 2010 14:36:51 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Martin Jansa <martin.jansa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: setlocalversion should respect srctree param
 when looking for auto.conf
References: <1279013676-23887-1-git-send-email-Martin.Jansa@gmail.com>
In-Reply-To: <1279013676-23887-1-git-send-email-Martin.Jansa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 11:34 AM, Martin Jansa wrote:
> * it works properly only when CWD == scrtree
> * with this patch:
>   jama src # /usr/src/linux/scripts/setlocalversion /usr/src/linux
>   -JaMa-00001-g18672de
> * without:
>   jama src # /usr/src/linux/scripts/setlocalversion /usr/src/linux
>   Error: kernelrelease not valid - run 'make prepare' to update it

This doesn't look correct, include/config/auto.conf is generated in the
build directory (*), where this script is called from by the Makefile.
If you call the script manually, you have to cd to the build directory
first.

(*) which is different from the source directory if you build with O=.

Michal
> 
> Signed-off-by: Martin Jansa <Martin.Jansa@gmail.com>
> ---
>  scripts/setlocalversion |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index d6a866e..41864d1 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -135,7 +135,7 @@ if $scm_only; then
>  	exit
>  fi
>  
> -if test -e include/config/auto.conf; then
> +if test -e "${srctree}/include/config/auto.conf"; then
>  	source "$_"
>  else
>  	echo "Error: kernelrelease not valid - run 'make prepare' to update it"

