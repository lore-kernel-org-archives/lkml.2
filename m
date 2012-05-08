Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2EHOri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:47:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42603 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2EHOrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205080859570.25669@router.home>
References: <CAP145pjtv-S2oHhn8_QfLKF8APtut4B9qPXK5QM8nQbxzPd2gw@mail.gmail.com>
	<alpine.DEB.2.00.1205071514040.6029@router.home>
	<CAP145piK2kW4F94pNdKpo_sGg8OD914exOtwCx2o+83jx5Toog@mail.gmail.com>
	<alpine.DEB.2.00.1205080859570.25669@router.home>
Date: Tue, 8 May 2012 16:47:37 +0200
Message-ID: <CAP145phLFDzoop_kUq-qN8a132Dj4oXsxJGcR_rv+LbZV-NObA@mail.gmail.com>
Subject: Re: mmap/clone returns ENOMEM with lots of free memory
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 4:02 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 7 May 2012, Robert Święcki wrote:
>
>> Yup (btw: I attached dump of some proc files and some debug commands
>> in the original e-mail - can be found here
>> http://marc.info/?l=linux-kernel&m=133640623421007&w=2 in case some
>> MTA removed them)
>>
>> CommitLimit:     1981528 kB
>> Committed_AS:    1916788 kB
>>
>> just not sure if Committed_AS should present this kind of value. Did I
>> just hit a legitimate condition, or may it suggest a bug? I'm a bit
>> puzzled cause
>
> This is a legitimate condition. No bug.
>>
>> root@ise-test:/proc# grep Mem /proc/meminfo
>> MemTotal:        3963060 kB
>> MemFree:         3098324 kB
>
> Physical memory is free in quantity but virtual memory is exhausted.
>
>> Also, some sysctl values:
>> vm.overcommit_memory = 2
>> vm.overcommit_ratio = 50
>
> Setting overcommit memory to 2 means that the app is strictly policed
> for staying within bounds on virtual memory. Dont do that.
>
> See linux source linux/Documentation/vm/overcommit-accounting for more
> details.

Thanks Christoph.

-- 
Robert Święcki
