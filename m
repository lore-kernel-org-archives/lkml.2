Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab0F2LYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:24:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56130 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0F2LYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nwnBPiOS57Rjtvih+PA2FUf6YkscfhsC+akSiwv9tZ5MmiYnHBQ6GL+ZU7ySUKXMPX
         u6OEvPqw7jalf2NNVpYoSNv/9lcumUEnxQDTSyqEHaAx2qK7XiwMcHO0ctvhlHj0VHP9
         /MJMTuwLH6uhNpNrioXNk9QwZ2KmWs4yX7GVQ=
MIME-Version: 1.0
In-Reply-To: <1277808215.1868.5.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	<1277808215.1868.5.camel@laptop>
Date: Tue, 29 Jun 2010 19:24:17 +0800
Message-ID: <AANLkTik4PXpgkc_ob-INohfmlTwe3wqDmif_ohXBxHHX@mail.gmail.com>
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in 
	kernel/sched_fair.c
From: shenghui <crosslonelyover@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/29 Peter Zijlstra <peterz@infradead.org>:
> On Tue, 2010-06-29 at 15:10 +0800, shenghui wrote:
>> I think some lock on the metadata can fix this issue, but we may
>> change plenty of code to add support for lock. I think the easist
>> way is just substacting nr_running before dequing tasks.
>
> But all that is fully serialized by the rq->lock.. so I'm really not
> seeing how this can happen.
>
>
>

I wonder is there any chance set_next_entity() can get NULL for
parameter se if so?
And will you please give me some instructions on where rq->lock
is required?

-- 


Thanks and Best Regards,
shenghui
