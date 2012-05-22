Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab2EVAEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:04:04 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60422 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2EVAD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:03:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Kok\, Auke-jan H" <auke-jan.h.kok@intel.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
	<87havchd14.fsf@xmission.com>
	<CABsxX9J+KVSbxVahg-iVsfeNDEM_H8+MrcBBejjCZFrcNCxwtA@mail.gmail.com>
Date: Mon, 21 May 2012 18:03:48 -0600
In-Reply-To: <CABsxX9J+KVSbxVahg-iVsfeNDEM_H8+MrcBBejjCZFrcNCxwtA@mail.gmail.com>
	(Auke-jan H. Kok's message of "Sat, 19 May 2012 11:39:14 -0700")
Message-ID: <87d35x6pzv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+oZkIchzozp82XDZN13C5lQAQuap/kuHU=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0038]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Kok\, Auke-jan H" <auke-jan.h.kok@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Trace event for capable().
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kok, Auke-jan H" <auke-jan.h.kok@intel.com> writes:

> On Fri, May 18, 2012 at 11:59 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Auke Kok <auke-jan.h.kok@intel.com> writes:
>>
>> > Add a simple trace event for capable().
>> >
>> > There's been a lot of discussion around capable(), and there
>> > are plenty of tools to help reduce capabilities' usage from
>> > userspace. A major gap however is that it's almost impossible
>> > to see or verify which bits are requested from either userspace
>> > or in the kernel.
>> >
>> > This patch adds a minimal tracer that will print out which
>> > CAPs are requested and whether the request was granted.
>>
>> A small comment assigned from the other issues.
>>
>> current->pid for anything going to userspace is broken,
>> and in fact current->pid should be killed on of these days.
>>
>> Which pid namespace is your tracer running in?
>
> init - I currently have no need for namespaces myself at all, and, as I replied
> to Serge and Eric already - I'll see if I can fis up the tracer with their
> suggestions.

Thanks.

A quick read of perf_event_open shows that the syscall is allowed by
unprivileged users in any context if sysctl_perf_event_paranoid is
set properly.  So it looks like the perf code needs to handle namespaces
properly if we are going to be reporting namespaced values like uid
and pids.  Even if no one cares today what about next week?

Eric
