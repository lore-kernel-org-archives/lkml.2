Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab0FKAeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:34:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50983 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab0FKAeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NgJhA1MTqQ84zH2lHf59fkbuybFgL8hR3GptN+ifigxFi9kU43oCXsrL/zEePoneEw
         GBI1ukbANQuY+WYB2d/Hej7ki8zcfBh1QTg7c+Kw7y9pqb9FiYRBXBPkFYcdCuLyih22
         Hl7o/0tMH3I1W9d+QASSlcpknXBPgROr3sM6Y=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1006101326440.20197@chino.kir.corp.google.com>
References: <AANLkTik6xP9vVEyW4QG-4RfZu-iEuHcl2pBV_-mfHP4y@mail.gmail.com>
	<alpine.DEB.2.00.1006101326440.20197@chino.kir.corp.google.com>
Date: Fri, 11 Jun 2010 08:34:21 +0800
Message-ID: <AANLkTinTm1kc1n_GS-nk6t46j1_ia8a8i0H7bHWlmVba@mail.gmail.com>
Subject: Re: oom killer and long-waiting processes
From: Ryan Wang <openspace.wang@gmail.com>
To: rientjes@google.com, mulyadi.santosa@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/11 David Rientjes <rientjes@google.com>:
> On Thu, 10 Jun 2010, Ryan Wang wrote:
>
>> Hi all,
>>
>>         I have one question about oom killer:
>> If many processes dealing with network communications,
>> but due to bad network traffic, the processes have to wait
>> for a very long time. And meanwhile they may consume
>> some memeory separately for computation. The number
>> of such processes may be large.
>>
>>         I wonder whether oom killer will kill these processes
>> when the system is under high pressure?
>>
>
> The kernel can deal with "high pressure" quite well, but in some cases
> such as when all of your RAM or your memory controller is filled with
> anonymous memory and cannot be reclaimed, the oom killer may be called to
> kill "something".  It prefers to kill something that will free a large
> amount of memory to avoid having to subsequently kill additional tasks
> when it kills something small first.
>
> If there are tasks that you'd either like to protect from the oom killer
> or always prefer in oom conditions, you can influence its decision-making
> from userspace by tuning /proc/<pid>/oom_adj of the task in question.
> Users typically set an oom_adj value of "-17" to completely disable oom
> killing of pid (the kernel will even panic if it can't find anything
> killable as a result of this!), a value of "-16" to prefer that pid gets
> killed last, and a value of "15" to always prefer pid gets killed first.
>
> Lowering a /proc/<pid>/oom_adj value for a pid from its current value (it
> inherits its value from the parent, which is usually 0) is only allowed by
> root, more specifically, it may only be done by the CAP_SYS_RESOURCE
> capability.
>
> You can refer to Documentation/filesystems/proc.txt for information on
> oom_adj.
>

Thanks all!
