Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030697Ab2I2CmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 22:42:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33753 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab2I2CmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 22:42:19 -0400
Message-ID: <50665FEB.6060309@oracle.com>
Date: Sat, 29 Sep 2012 10:41:47 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to cleanup
References: <1347039854.6288.8.camel@thor> <504A3FA9.1050502@zytor.com>  <504D6490.2060606@oracle.com> <1348853876.2229.22.camel@thor>
In-Reply-To: <1348853876.2229.22.camel@thor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-29 01:37, Peter Hurley wrote:
> On Sun, 2012-09-09 at 23:54 -0400, zhenzhong.duan wrote:
>> On 2012-09-08 02:40, H. Peter Anvin wrote:
>>> On 09/07/2012 10:44 AM, Peter Hurley wrote:
>>>
>>>> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c
>>>> b/arch/x86/kernel/cpu/mtrr/cleanup.c
>>> I really don't like it as it introduces yet another user of max_pfn,
>>> which should be going away.  Furthermore, the better question is what
>>> remaining needs there are for MTRR cleanup; historically the reason
>>> was that it prevented the display from being mapped WC via MTRR due to
>>> the MTRR conflict resolution rules favoring UC.
>> For a large memory system, mtrr_cleanup offten fail in most case. Even
>> if it succeed, it often occupy all of MTRR entrys.
>> How was display mapped as WC in above case?
> Without this patch, mtrr_cleanup could not optimize. The original MTRR
> setup from BIOS remained, which left the display as UC (and a lot of log
> spew).
Hi,
I am confused here.
Does HPA means mtrr_cleanup's purpose is to occupy all mtrr entrys and 
prevent display setting a WC entry in it?
As page level will do that in current code? If it is, then mtrr_cleanup 
could be removed now.
>
>> Why did bios give a lot of space then real mem, for hotplug?
> I assume the reason was for hotplug.
>
> An interesting side note: more recent revisions of this BIOS (rev. A11)
> report one less variable MTRR (so, IA32_MTRRCAP is writable?)
 From manual, it's readonly, writing it will lead to #GP.
>
>>> However, the right way to fix that is to use the PAT interfaces, which
>>> doesn't have this drawback -- then MTRR cleanup becomes entirely
>>> superfluous and the problem goes away.
>> Do you mean disable MTRR totally here?
> Well, since PAT entries marked WC override all MTRR settings, whatever
> the BIOS set the variable MTRRs to becomes irrelevant, so not disabled
> but rather ignored.
Oh, I see, WC in page level take precedence. Is the fix already in upstream?
thanks
zduan
