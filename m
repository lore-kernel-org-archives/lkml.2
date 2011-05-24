Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1EXIq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:46:56 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59394 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1EXIqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oyqKVObDRan42GEjkKbD4WSgCf6Bssa4ZIrwdeNu1tpjaGCSleqbWs7IxRri8dVbGM
         RHnF8U80NTyCaFWEKp7QXaDUAoPgLyhciMBb8S2z7c5ui3de27VMeSf8+9gXFlsYfVpk
         WM9nKEWuoyBEChyyE1xP5/USBpliVxsS02Z1w=
MIME-Version: 1.0
In-Reply-To: <4DDB0FB2.9050300@jp.fujitsu.com>
References: <4DD61F80.1020505@jp.fujitsu.com>
	<4DD6207E.1070300@jp.fujitsu.com>
	<BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>
	<4DDB0FB2.9050300@jp.fujitsu.com>
Date: Tue, 24 May 2011 17:46:54 +0900
Message-ID: <BANLkTinKm=m8zdPGN0Trpy4HtEFyxMYzPA@mail.gmail.com>
Subject: Re: [PATCH 4/5] oom: don't kill random process
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:53 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>>> +       /*
>>> +        * chosen_point==1 may be a sign that root privilege bonus is too
>>> large
>>> +        * and we choose wrong task. Let's recalculate oom score without
>>> the
>>> +        * dubious bonus.
>>> +        */
>>> +       if (protect_root&&  (chosen_points == 1)) {
>>> +               protect_root = 0;
>>> +               goto retry;
>>> +       }
>>
>> The idea is good to me.
>> But once we meet it, should we give up protecting root privileged
>> processes?
>> How about decaying bonus point?
>
> After applying my patch, unprivileged process never get score-1. (note,
> mapping
> anon pages naturally makes to increase nr_ptes)

Hmm, If I understand your code correctly, unprivileged process can get
a score 1 by 3% bonus.
So after all, we can get a chosen_point with 1.
Why I get a chosen_point with 1 is as bonus is rather big, I think.
So I would like to use small bonus than first iteration(ie, decay bonus).

>
> Then, decaying don't make any accuracy. Am I missing something?

Maybe I miss something.  :(




-- 
Kind regards,
Minchan Kim
