Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0F1EPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 00:15:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51838 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0F1EPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 00:15:39 -0400
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <87d3vfeage.fsf@basil.nowhere.org>
	<4C24C279.3050206@austin.ibm.com>
	<20100628110658.387B.A69D9226@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 27 Jun 2010 21:15:29 -0700
In-Reply-To: <20100628110658.387B.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's message of "Mon\, 28 Jun 2010 11\:20\:27 +0900 \(JST\)")
Message-ID: <m14ognkd26.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] memory hotplug disable boot option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

>> On 06/25/2010 04:19 AM, Andi Kleen wrote:
>> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
>> > 
>> >>> Proposed patch to disable memory hotplug via a boot option,
>> >>> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
>> >>> prevents the creation of the memory sysfs directories for memory sections.
>> >>>
>> >>> This patch is meant to help alleviate very long boot times on systems with
>> >>> large memory (1+ TB) and many memory sections (10's of thousands).
>> >>
>> >> Why making simple /sys file is so slowly? Couldn't we fix such performance
>> >> problem?
>> 
>> The issue is the large number of sysfs memory directories that get created.
>> On a system with 1 TB of memory I am seeing ~63,00 directories.  The long
>> creation time is due to the string compare check in sysfs code to ensure
>> we are not creating a directory with a duplicate name.
>
> Ah, I see. probably this is sysfs issue. So Let's cc Greg and Eric.
> Greg, I have dumb question. Why sysfs call strcmp() so heavily? I mean why sysfs
> don't have hash based name dupliation check?

Simplicity of the current implementation.

I have a prototype patch sitting around somewhere.  I think ultimately
it makes sense to do something like extN's htree directory structure
in sysfs.  I wanted to get the tagged sysfs support in before I worked
on scalability because that slightly changes the requirements.

Improving the scalability here is certainly worth doing, but I am slightly
concerned there is something else algorithmically wrong if this is still
going to take 33 minutes to boot with 2TB.

Eric
