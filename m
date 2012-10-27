Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024Ab2J0BzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 21:55:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab2J0BzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 21:55:20 -0400
Message-ID: <508B3EED.2080003@vlnb.net>
Date: Fri, 26 Oct 2012 21:54:53 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org>
In-Reply-To: <20121025051445.GA9860@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:FymgKGcHwBXGZDF2VdDouopMp8mtY1fyoPpmJLM0FnZ
 3BlafVhUJCJlo08YGAiA//PJ+all7uAV+ue9YFnR2ey1KdU7UJ
 awCwthqjOiouuyHCBihqaQsX7XRKIhJNK2gJHHmffTPGQyA9H3
 GYAEyOuHj5ruGz2s2Q24kniw4ZRL64ovyQx5PQMIuqSGOkbuX1
 RMqzjTJ/LllYMiNUEuH6hc5TDhQW0XpxbwKg7IZ0811gs1S2aQ
 C4Uv1t6HerVoaCy/HMWicbXkgkL2HSDFDzgIbr1QyBJgpS3uOC
 Rd3yG1rXChT1h6pT0DDDDV42HEI3MHZ+8vYKyXSym4aaWqJ0eA
 iA2v1mOuq9VsXhk5HReg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Theodore Ts'o, on 10/25/2012 01:14 AM wrote:
> On Tue, Oct 23, 2012 at 03:53:11PM -0400, Vladislav Bolkhovitin wrote:
>> Yes, SCSI has full support for ordered/simple commands designed
>> exactly for that task: to have steady flow of commands even in case
>> when some of them are ordered.....
>
> SCSI does, yes --- *if* the device actually implements Tagged Command
> Queuing (TCQ).  Not all devices do.
>
> More importantly, SATA drives do *not* have this capability, and when
> you compare the price of SATA drives to uber-expensive "enterprise
> drives", it's not surprising that most people don't actually use
> SCSI/SAS drives that have implemented TCQ.

What different in our positions is that you are considering storage as something 
you can connect to your desktop, while in my view storage is something, which 
stores data and serves them the best possible way with the best performance.

Hence, for you the least common denominator of all storage features is the most 
important, while for me to get the best of what possible from storage is the most 
important.

In my view storage should offload from the host system as much as possible: data 
movements, ordered operations requirements, atomic operations, deduplication, 
snapshots, reliability measures (eg RAIDs), load balancing, etc.

It's the same as with 2D/3D video acceleration hardware. If you want the best 
performance from your system, you should offload from it as much as possible. In 
case of video - to the video hardware, in case of storage - to the storage. The 
same as with video, for storage better offload - better performance. On hundreds 
of thousands IOPS it's clearly visible.

Price doesn't matter here, because it's completely different topic.

> SATA's Native Command
> Queuing (NCQ) is not equivalent; this allows the drive to reorder
> requests (in particular read requests) so they can be serviced more
> efficiently, but it does *not* allow the OS to specify a partial,
> relative ordering of requests.

And so? If SATA can't do it, does it mean that nobody else can't do it too? I know 
a plenty of non-SATA devices, which can do the ordering requirements you need.

Vlad
