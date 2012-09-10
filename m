Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2IJDyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:54:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29408 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2IJDyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:54:10 -0400
Message-ID: <504D6490.2060606@oracle.com>
Date: Mon, 10 Sep 2012 11:54:56 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to cleanup
References: <1347039854.6288.8.camel@thor> <504A3FA9.1050502@zytor.com>
In-Reply-To: <504A3FA9.1050502@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



于 2012-09-08 02:40, H. Peter Anvin 写道:
> On 09/07/2012 10:44 AM, Peter Hurley wrote:
> \>
>> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c 
>> b/arch/x86/kernel/cpu/mtrr/cleanup.c
>
> I really don't like it as it introduces yet another user of max_pfn, 
> which should be going away.  Furthermore, the better question is what 
> remaining needs there are for MTRR cleanup; historically the reason 
> was that it prevented the display from being mapped WC via MTRR due to 
> the MTRR conflict resolution rules favoring UC.
For a large memory system, mtrr_cleanup offten fail in most case. Even 
if it succeed, it often occupy all of MTRR entrys.
How was display mapped as WC in above case?
Why did bios give a lot of space then real mem, for hotplug?
>
> However, the right way to fix that is to use the PAT interfaces, which 
> doesn't have this drawback -- then MTRR cleanup becomes entirely 
> superfluous and the problem goes away.
Do you mean disable MTRR totally here?
Regards
zduan
