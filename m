Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab2DZTdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:33:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34728 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326Ab2DZTdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F7F3CA9.1030500@redhat.com>
References: <1333737920-17555-1-git-send-email-yinghan@google.com>
	<4F7F3CA9.1030500@redhat.com>
Date: Thu, 26 Apr 2012 12:33:36 -0700
Message-ID: <CALWz4iyKDcrLoK4Dtnwwq6OvDAiEyb72iV6dezwKmoZWhkVDSw@mail.gmail.com>
Subject: Re: [PATCH V8] Eliminate task stack trace duplication
From: Ying Han <yinghan@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

++cc x86 people which I forgot this time ..

--Ying

On Fri, Apr 6, 2012 at 11:57 AM, Rik van Riel <riel@redhat.com> wrote:
> On 04/06/2012 02:45 PM, Ying Han wrote:
>>
>> The problem with small dmesg ring buffer like 512k is that only limited
>> number
>> of task traces will be logged. Sometimes we lose important information
>> only
>> because of too many duplicated stack traces. This problem occurs when
>> dumping
>> lots of stacks in a single operation, such as sysrq-T.
>>
>> This patch tries to reduce the duplication of task stack trace in the dump
>> message by hashing the task stack. The hashtable is a 32k pre-allocated
>> buffer
>> during bootup. Each time if we find the identical task trace in the task
>> stack,
>> we dump only the pid of the task which has the task trace dumped. So it is
>> easy
>> to back track to the full stack with the pid.
>
>
>> Signed-off-by: Ying Han<yinghan@google.com>
>
>
> Acked-by: Rik van Riel <riel@redhat.com>
>
> --
> All rights reversed
