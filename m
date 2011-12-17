Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1LQW3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:29:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52611 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1LQW3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:29:21 -0500
X-Greylist: delayed 1015 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Dec 2011 17:29:21 EST
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "mingo\@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra\@chello.nl" <a.p.zijlstra@chello.nl>,
        Pavel Emelianov <xemul@parallels.com>,
        "drosenberg\@vsecurity.com" <drosenberg@vsecurity.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eparis\@redhat.com" <eparis@redhat.com>,
        "bfields\@fieldses.org" <bfields@fieldses.org>,
        James Bottomley <jbottomley@parallels.com>,
        "devel\@openvz.org" <devel@openvz.org>
References: <20111212174709.7084.54702.stgit@localhost6.localdomain6>
	<20111212175000.7084.94219.stgit@localhost6.localdomain6>
	<20111212145208.75490b41.akpm@linux-foundation.org>
	<4EE714BC.5040408@parallels.com>
Date: Sat, 17 Dec 2011 14:30:55 -0800
In-Reply-To: <4EE714BC.5040408@parallels.com> (Stanislav Kinsbursky's message
	of "Tue, 13 Dec 2011 13:02:52 +0400")
Message-ID: <m162herfts.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/m/7yWOJqEDqq+OgyBimQLRNaExmQZN0s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 1/2] SYSCTL: root unregister routine introduced
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> 13.12.2011 02:52, Andrew Morton пишет:
>> On Mon, 12 Dec 2011 21:50:00 +0300
>> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>>
>>> This routine is required for SUNRPC sysctl's, which are going to be allocated,
>>> processed and destroyed per network namespace context.
>>> IOW, new sysctl root will be registered on network namespace creation and
>>> thus have to unregistered before network namespace destruction.
>>>
>>
>> It's a bit suspicious that such a mature subsystem as sysctl newly
>> needs its internals exported like this.  Either a) the net namespaces
>> work is doing something which hasn't been done before or b) it is doing
>> something wrong.
>>
>> So, please explain further so we can confirm that it is a) and not b).
>>
>
> Hello, Andrew.
> The goal is to provide an ability to control and modify data by sysctl's in
> network namespace context. This is done by "net" sysctl's.
> But there are two more issues to solve:
> 1) Sysctl's have to be in /proc/sys/sunrpc

The sysctl root has nothing to with what directory the files show up in,
so this should not be an issue.

> 2) Sysctl's content should be accessible from creator's network context (not
> current user ones's).

Making the sunrpc sysctls per network namespace would seem to address
this.    I don't see why you would need a new root to handle this case.

Eric
