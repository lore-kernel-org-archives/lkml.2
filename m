Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1CHPXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:23:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38884 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1CHPXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DLsJEMZ52A6Cd0y+z++vSdGwhiJqH9ySahfWDXccflhimyAXYTxKy4eyfngulATKng
         RGGieDg3eR9SS8iNYbJygDEYSg3as2KLM/RvrQLqk0uqS5Fij0N64eu2JQU8FSPasLax
         J1cj+RA+xWakMZmIQVQfCDxdQPtHASgh/uO6s=
MIME-Version: 1.0
In-Reply-To: <20110308141847.GB1837@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
	<20101223034229.GF1739@nowhere>
	<201101300108.32383.roucaries.bastien@gmail.com>
	<20110308141847.GB1837@nowhere>
Date: Tue, 8 Mar 2011 16:22:59 +0100
Message-ID: <AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 3:18 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Sun, Jan 30, 2011 at 01:08:29AM +0100, Bastien ROUCARIES wrote:
>> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
>> Hi,
>>
>> I take me more than two days of testing to reporduce this bugs with trace enabled. My filesystem was quite slow and this bugs seems
>> to be timing related.
>>
>> One patern that trigger this bug is git. Doing a lot of git work of my desktop crash my machine.
>>
>> Moreover, trying to reproduce this bug lead to data loss. I have rebuilded twice my / partition using --rebuild-tree, and restored
>> my home partition three times using backups.
>>
>> My log is here.
>>
>> Do you need more information?
>>
>> Bastien
>
> You have a first series of hung task report from 19440.852298 to 19440.880024
> then it's followed by the traces and then again with a hung task report at
> 19560.880084. But there is only one task stuck in that 2nd report. Did
> you report your whole dmesg there or have you cut it? If it's your
> whole dmesg then it means the other tasks from the first report have released
> from their hung state. So the queued writers have been released by someone
> who closed the journal.

I have reported the whole stuff. But because my log need to go to my
disk, we could have loss something

> This could confirm the theory that someone has opened the journal and
> spent way too much time before releasing it. Or something else.
> In any case tell me, there are other tests we can run.
>

Ok bastien
