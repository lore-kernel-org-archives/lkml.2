Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0KIVt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:49:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48470 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0KIVt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=db53FnOm1ucf6baoELiBQ/gcbv4M2iYuRTk4k1uF32/3MQgvAxUueQplx0+mP5Qjqu
         +n+q5D5JtA+B9gvV2sSZdTmwb32LanFKX7eTji/qksU5hyQbBYAlxx9ePbjU4vG3yjHQ
         odmKqv4FZCYZAHRoEahHNrGqVX7nYtPbHexss=
MIME-Version: 1.0
In-Reply-To: <4CD9B07E.70502@fusionio.com>
References: <AANLkTi=xj6xW5SnrdQos4P-MtJP8+fwfaa3r7LPfdLh4@mail.gmail.com>
	<20101107185433.GD15561@linux.vnet.ibm.com>
	<4CD7FAFD.1060802@fusionio.com>
	<20101108135204.GE2580@linux.vnet.ibm.com>
	<4CD80162.9000607@fusionio.com>
	<4CD9B07E.70502@fusionio.com>
Date: Tue, 9 Nov 2010 21:49:54 +0000
Message-ID: <AANLkTi=hbObSQC2=mwtb6cy399Srt-mL47zgfvth57fQ@mail.gmail.com>
Subject: Re: [2.6.37-rc1] sys_ioprio_set and RCU locking...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2010 20:35, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2010-11-08 14:55, Jens Axboe wrote:
>>>>>> Take the RCU lock for read across acquiring the pointer to the task
>>>>>> credentials and dereferencing it.
>>>>>
>>>>> Jens, does this look sane?
>>>>
>>>> Yes, looks clean enough to me.
>>>
>>> Very good!  Are you willing to take the patch in your tree?
>>
>> Certainly, I'm in the middle of patch monkeying now anyway. Will queue
>> it up.
>
> The patch was buggy, I discovered that it does not do the proper
> RCU unlock if we fail the uid match. Merged version here:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1a882abdbf9579ad0e5655f928e4ede30db301e6

Brown paper bag moment! Good catch, Jens.

Dan
-- 
Daniel J Blueman
