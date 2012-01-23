Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2AWQl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:41:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56118 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2AWQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:41:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Earl Chew <echew@ixiacom.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org>
	<4F1D8180.9030509@ixiacom.com> <m1mx9enzr0.fsf@fess.ebiederm.org>
Date: Mon, 23 Jan 2012 08:43:57 -0800
In-Reply-To: <m1mx9enzr0.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Mon, 23 Jan 2012 08:35:15 -0800")
Message-ID: <m1d3aanzci.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+q/AymNcsijer+xRY/oTGIqFr7Vn8DRC4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

>>
>> [ I also note that the patch allows multiple short reads (not necessarily
>>   just a single byte at a time) from these entries in procfs. ]
>>
>> I think there is a reasonable userspace expectation that entities
>> that present themselves as text files to produce results that are
>> consistent with the userspace model of a text file.
>>
>> For a more concrete example, consider the following BusyBox ash(1) code:
>>
>> read X < /proc/sys/kernel/threads-max
>> Y=$(cat /proc/sys/kernel/threads-max)
>>
>> read A < /proc/sys/kernel/core_pattern
>> B=$(cat /proc/sys/kernel/core_pattern)
>
>
>> The fact that these yield different results is surprising given that
>> the user sees these as text files.

To be precise /proc/sys/kernel/threads-max does not present itself as
an ordinary text file.  It reports that it's file length is 0 bytes
long.   That is different from an ordinary text file.

Eric
