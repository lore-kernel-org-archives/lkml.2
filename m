Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0FDEtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:49:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41935 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0FDEtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=utmJlad7gnLsHeLJ6hecBpOEjj2Vw6QSCS4mgYHFGRoHzlupdBCPnLvZbQTxDx0+oX
         LH68r0PwDzCuNTwpzI82jJv87+6ZIplJnA+6Jicucoo7M6ASs2oCYQD8rNBs8q5N1z/l
         CJzujkdrvfH8NF9mKONcTM1taQBM8dgufUEz4=
Date: Fri, 4 Jun 2010 12:53:41 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, mmarek@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: decodecode: use /bin/bash
Message-ID: <20100604045341.GD5167@cr0.nay.redhat.com>
References: <1275581686-19745-1-git-send-email-rabin@rab.in>
 <20100603092458.d0d603e3.randy.dunlap@oracle.com>
 <20100603165902.GA20721@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603165902.GA20721@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:29:03PM +0530, Rabin Vincent wrote:
>On Thu, Jun 03, 2010 at 09:24:58AM -0700, Randy Dunlap wrote:
>> On Thu,  3 Jun 2010 21:44:46 +0530 Rabin Vincent wrote:
>> 
>> > 5358db ("scripts: add ARM support to decodecode") added a few bashims to
>> > the decodecode script, so explicitly ask for bash.
>> > 
>> > Signed-off-by: Rabin Vincent <rabin@rab.in>
>> > ---
>> > Alternatively, I have a patch to remove the bashisms, if that's preferred.
>> 
>> Yes, that's what we usually prefer to do.
>> Please post it.
>
>Here it is:
>
>From f729122bcd237f32c9f667e5644c6114ddc795af Mon Sep 17 00:00:00 2001
>From: Rabin Vincent <rabin@rab.in>
>Date: Thu, 3 Jun 2010 21:33:46 +0530
>Subject: [PATCH] scripts: decodecode: remove bashisms
>
>Remove bashisms to make scripts/decodecode work with other shells.
>
>Signed-off-by: Rabin Vincent <rabin@rab.in>
>---
> scripts/decodecode |   10 +++++-----
> 1 files changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/scripts/decodecode b/scripts/decodecode
>index 8b30cc3..18ba881 100755
>--- a/scripts/decodecode
>+++ b/scripts/decodecode
>@@ -40,7 +40,7 @@ echo $code
> code=`echo $code | sed -e 's/.*Code: //'`
> 
> width=`expr index "$code" ' '`
>-width=$[($width-1)/2]
>+width=$((($width-1)/2))
> case $width in
> 1) type=byte ;;
> 2) type=2byte ;;
>@@ -48,10 +48,10 @@ case $width in
> esac
> 
> disas() {
>-	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s &> /dev/null
>+	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s > /dev/null 2>&1


I am a bit surprised to see this is bash specific.

Anyway, this patch looks good for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
