Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2IPQx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 12:53:29 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:39556 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2IPQx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 12:53:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge@hallyn.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Aristeu Rozanski <aris@ruivo.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20120913205827.GO7677@google.com>
	<20120914183641.GA2191@cathedrallabs.org>
	<20120915022037.GA6438@mail.hallyn.com>
	<87wqzv7i08.fsf_-_@xmission.com>
	<20120915220520.GA11364@mail.hallyn.com> <87y5kazuez.fsf@xmission.com>
	<20120916122112.3f16178d@pyramind.ukuu.org.uk>
	<87sjaiuqp5.fsf@xmission.com> <87d31mupp3.fsf@xmission.com>
	<5055D4D1.3070407@hallyn.com> <87k3vuqc5l.fsf@xmission.com>
	<5055FB2A.1020103@hallyn.com>
Date: Sun, 16 Sep 2012 09:53:09 -0700
In-Reply-To: <5055FB2A.1020103@hallyn.com> (Serge Hallyn's message of "Sun, 16
	Sep 2012 11:15:38 -0500")
Message-ID: <87pq5loqoa.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19sjCPJspC0cFZtrLSYI0uhcI0a1i1qLgo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: Controlling devices and device namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge@hallyn.com> writes:

>>> That's what I said a few emails ago :)  The device cgroup was meant as
>>> a short-term workaround for lack of user (and device) namespaces.
>>
>> I am saying something stronger.  The device cgroup doesn't seem to have
>> a practical function now.
>
> "Now" is wrong.  The user namespace is not complete and not yet usable for a
> full system container.  We still need the device control group.

Dropping cap mknod, and not having any device nodes you can mount
a filesystem with device nodes, plus mount namespace work to only allow
you to have access to proper device nodes should work today.  And I
admit the user namespace as I have it coded in my tree does make this
simpler.

But I agree "Now" is too soon until we have actually demonstrated
something else.

Eric
