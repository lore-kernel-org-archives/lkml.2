Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1DOFlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:41:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42067 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1DOFls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZV9tJMPJs9e0PGwV+vOUErBVP/q+3ZJ+M737bfXpmqDePCV324VtDsDJLMpaep9B+3
         j/thCpWxXyVS4Qcm7FhIaaYc01ABzJ7eOzksgtiTI7Xcug4B6T2q/AC/YxV87zD/lDfu
         zfiTj9sfRZcsGllqkonrWJDiEYRHi1eQzPRW4=
MIME-Version: 1.0
In-Reply-To: <1302842039-7190-1-git-send-email-namhyung@gmail.com>
References: <1302842039-7190-1-git-send-email-namhyung@gmail.com>
Date: Fri, 15 Apr 2011 14:41:47 +0900
Message-ID: <BANLkTinDFrbUNPnUmed2aBTu1_QHFQie-w@mail.gmail.com>
Subject: Re: [PATCH] mempolicy: reduce references to the current
From: Minchan Kim <minchan.kim@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 1:33 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Remove duplicated reference to the 'current' task using a local
> variable. Since refering the current can be a burden, it'd better
> cache the reference, IMHO. At least this saves some bytes on x86_64.
>
>  $ size mempolicy-{old,new}.o
>     text    data    bss     dec     hex filename
>    25203    2448   9176   36827    8fdb mempolicy-old.o
>    25136    2448   9184   36768    8fa0 mempolicy-new.o
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Hi Namhyung,

The patch looks good to me. :)
But I have a nitpick. "curr" is rather awkward to me.
We have been used "tsk" and "p" instead of "curr" for task_struct.
But I don't like "p" since it has no meaning. So for consistency,
could you change it with "tsk"?

Thanks.
-- 
Kind regards,
Minchan Kim
