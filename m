Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1EDOV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:21:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1EDOV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F3pZabLR1/Zjhheo/3BuGpmQ6MzVYaHbgvw41/ANYnXFvWNWbM88JAkirEjRAlg2f0
         v85juncf+3N3L/4YNNeA9pbohz55jq1/AWyaiATQvDjbAOfmJOngmOvK16pPGjuwoYsy
         VVnYozfYjvHQSqUW4jEJIMT93cTFx3i9GY33w=
MIME-Version: 1.0
In-Reply-To: <BANLkTik17MGwWwFb=CzBduFy9Mn-Ze+ptA@mail.gmail.com>
References: <BANLkTimLd-qY-OeKqnf2EoTfvAHWQZVchw@mail.gmail.com>
	<BANLkTi=xz4w3p4bc5T4-YvkC3tYdwKhWGA@mail.gmail.com>
	<BANLkTik17MGwWwFb=CzBduFy9Mn-Ze+ptA@mail.gmail.com>
Date: Wed, 4 May 2011 15:21:26 +0100
X-Google-Sender-Auth: yKW1mfZOybe_Gf1IRP6KiqoVQJs
Message-ID: <BANLkTi=WYk3_wQ8R1x9JD3-A+asO3cyo4Q@mail.gmail.com>
Subject: Re: [ARM]crash on 2.6.35.11
From: Catalin Marinas <catalin.marinas@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fixing up the linux-arm-kernel list address)

On 4 May 2011 14:18, naveen yadav <yad.naveen@gmail.com> wrote:
> On Wed, May 4, 2011 at 3:55 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> On 4 May 2011 11:09, naveen yadav <yad.naveen@gmail.com> wrote:
>>> We are running linux kernel 2.6.35.11 on Cortex a-8. when I run a
>>> simple program expect to give oom.
>>>  But it crash with following crash log
>>
>> Could you post the full kernel boot log and .config file?
>
> Pls find attached log

It looks like a problem with the memory configuration on your board.
You have sparsemem sections which are not fully populated. The
mainline kernel still has problems in this area.

You can try this patch (not sure it applies cleanly on 2.6.35 but it's
not difficult to fix):

http://article.gmane.org/gmane.linux.ports.arm.kernel/112994

-- 
Catalin
