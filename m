Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0FCS1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:27:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45946 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0FCS1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:27:42 -0400
Date: Thu, 3 Jun 2010 11:25:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rabin Vincent <rabin@rab.in>
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: decodecode: use /bin/bash
Message-Id: <20100603112542.326a45b7.randy.dunlap@oracle.com>
In-Reply-To: <20100603171812.GA23367@debian>
References: <1275581686-19745-1-git-send-email-rabin@rab.in>
	<20100603092458.d0d603e3.randy.dunlap@oracle.com>
	<20100603171812.GA23367@debian>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C07F3E8.0083:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 22:48:12 +0530 Rabin Vincent wrote:

> On Thu, Jun 03, 2010 at 09:24:58AM -0700, Randy Dunlap wrote:
> > On Thu,  3 Jun 2010 21:44:46 +0530 Rabin Vincent wrote:
> > 
> > > 5358db ("scripts: add ARM support to decodecode") added a few bashims to
> > > the decodecode script, so explicitly ask for bash.
> > > 
> > > Signed-off-by: Rabin Vincent <rabin@rab.in>
> > > ---
> > > Alternatively, I have a patch to remove the bashisms, if that's preferred.
> > 
> > Yes, that's what we usually prefer to do.
> > Please post it.
> 
> Here it is:

Works for me.  Thanks.


> From f729122bcd237f32c9f667e5644c6114ddc795af Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin@rab.in>
> Date: Thu, 3 Jun 2010 21:33:46 +0530
> Subject: [PATCH] scripts: decodecode: remove bashisms
> 
> Remove bashisms to make scripts/decodecode work with other shells.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  scripts/decodecode |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/decodecode b/scripts/decodecode
> index 8b30cc3..18ba881 100755
> --- a/scripts/decodecode
> +++ b/scripts/decodecode
> @@ -40,7 +40,7 @@ echo $code
>  code=`echo $code | sed -e 's/.*Code: //'`
>  
>  width=`expr index "$code" ' '`
> -width=$[($width-1)/2]
> +width=$((($width-1)/2))
>  case $width in
>  1) type=byte ;;
>  2) type=2byte ;;
> @@ -48,10 +48,10 @@ case $width in
>  esac
>  
>  disas() {
> -	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s &> /dev/null
> +	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s > /dev/null 2>&1
>  
> -	if [ "$ARCH" == "arm" ]; then
> -		if [ $width == 2 ]; then
> +	if [ "$ARCH" = "arm" ]; then
> +		if [ $width -eq 2 ]; then
>  			OBJDUMPFLAGS="-M force-thumb"
>  		fi
>  
> @@ -59,7 +59,7 @@ disas() {
>  	fi
>  
>  	${CROSS_COMPILE}objdump $OBJDUMPFLAGS -S $1.o | \
> -		grep -v "/tmp\|Disassembly\|\.text\|^$" &> $1.dis
> +		grep -v "/tmp\|Disassembly\|\.text\|^$" > $1.dis 2>&1
>  }
>  
>  marker=`expr index "$code" "\<"`
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
