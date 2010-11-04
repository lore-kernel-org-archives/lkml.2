Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0KDCZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 22:25:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39492 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0KDCZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VtaLaIiVzEMRe0PGEkthhXywnjjkmN/fHrIf3RCLAlcdMnoe7J2RCu+lOAwhPa0nKN
         cVhkbYicIimDOUb3CMdCU0x3/JLGcmGx1JFn5A201/KkjVT8IcJgzfyM207xqTxZr080
         T+WBLgUNV210/HWzmnAEeqTZAr3Sc8yMq8cPU=
MIME-Version: 1.0
In-Reply-To: <20101103162015.99475a0b.randy.dunlap@oracle.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
	<20101103162015.99475a0b.randy.dunlap@oracle.com>
Date: Thu, 4 Nov 2010 10:25:09 +0800
Message-ID: <AANLkTin5PphTtZaesEU3U0PA8NJv=Jmis8yQF6b=KbeG@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc1 (scsi_debug: list corruption)
From: Xiaotian Feng <xtfeng@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 7:20 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>
> [  102.555847] calling  scsi_debug_init+0x0/0x704 [scsi_debug] @ 3337
> Nov  3 16:06:12 control kernel: [  102.555847] calling  scsi_deb[  102.622974] scsi_debug: host protection
> [  102.627513] scsi4 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
> Nov  3 16:06:13 control kernel: [  102.639095] initcall scsi_debug_init+0x0/0x704 [scsi_debug] returned 0 after 75039 usecs
> Nov  3 16:06:13 [  102.651072] ------------[ cut here ]------------
> [  102.657373] WARNING: at /local/linsrc/lnx-2637-rc1/lib/list_debug.c:26 __list_add+0x4d/0xa5()
> [  102.666012] Hardware name: OptiPlex GX620
> [  102.671396] list_add corruption. next->prev should be prev (ffffffff81ae5e50), but was 6b6b6b6b6b6b6b6b. (next=ffff88006c880590).

This might be related with net rds percpu_counter corruption. Does
following patch fix your issue?
http://patchwork.ozlabs.org/patch/69939/

>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
