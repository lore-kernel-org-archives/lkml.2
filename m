Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1EXJUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:20:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54889 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab1EXJUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DsIvydloaVXVW8+bwmgfNdlyEbL7DN4/+20NmzsPA0Lpf/vCA+UsTCf/Im8mp1ItJu
         NWEC85ZuhSAcTIMmH6hLlMIW9aan5/fBAGeGJRJIfz8YLRI0kVpcxAbWg9USEJed8ATz
         oYtRKCYMDZPlQ6uRCTcaFlauO3kGM2w5CCHyA=
MIME-Version: 1.0
In-Reply-To: <4DDB75D8.1000804@jp.fujitsu.com>
References: <4DD61F80.1020505@jp.fujitsu.com>
	<4DD6207E.1070300@jp.fujitsu.com>
	<BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>
	<4DDB0FB2.9050300@jp.fujitsu.com>
	<BANLkTinKm=m8zdPGN0Trpy4HtEFyxMYzPA@mail.gmail.com>
	<4DDB711B.8010408@jp.fujitsu.com>
	<BANLkTik5tXv+k9tk2egXgmBRzcBD5Avjkw@mail.gmail.com>
	<4DDB75D8.1000804@jp.fujitsu.com>
Date: Tue, 24 May 2011 18:20:51 +0900
Message-ID: <BANLkTime4C8nk0TBOfd2NT4mEEtLN6ZYaQ@mail.gmail.com>
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

On Tue, May 24, 2011 at 6:09 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> Hmm, If I understand your code correctly, unprivileged process can get
>>>> a score 1 by 3% bonus.
>>>
>>> 3% bonus is for privileged process. :)
>>
>> OMG. Typo.
>> Anyway, my point is following as.
>> If chose_point is 1, it means root bonus is rather big. Right?
>> If is is, your patch does second loop with completely ignore of bonus
>> for root privileged process.
>> My point is that let's not ignore bonus completely. Instead of it,
>> let's recalculate 1.5% for example.
>
> 1) unpriviledged process can't get score 1 (because at least a process need one
>   anon, one file and two or more ptes).
> 2) then, score=1 mean all processes in the system are privileged. thus decay won't help.
>
> IOW, never happen privileged and unprivileged score in this case.

I am blind. Thanks for open my eyes, KOSAKI.


-- 
Kind regards,
Minchan Kim
