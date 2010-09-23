Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0IWPO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:14:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44298 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0IWPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:14:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: hadi@cyberus.ca
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	<m1hbhgq1v1.fsf@fess.ebiederm.org> <1285240926.5036.7.camel@bigi>
Date: Thu, 23 Sep 2010 08:14:50 -0700
In-Reply-To: <1285240926.5036.7.camel@bigi> (jamal's message of "Thu, 23 Sep
	2010 07:22:06 -0400")
Message-ID: <m139t0jxud.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;hadi@cyberus.ca
X-Spam-Relay-Country: 
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jamal <hadi@cyberus.ca> writes:

> On Thu, 2010-09-23 at 01:51 -0700, Eric W. Biederman wrote:
>> Take advantage of the new abstraction and allow network devices
>> to be placed in any network namespace that we have a fd to talk
>> about.
>> 
>
> So ... why just netdevice? could you allow migration of other
> net "items" eg a route table since they are all tagged by
> netns?

For this patchset because we only support migrating physical
network devices between network namespaces today.

In the bigger picture migrating things between network namespaces is
race prone.  Fixing those races probably would reduce network stack
performance and increase code complexity for not particularly good
reason.  Network devices are special because they are physical hardware
and in combination with the rule that all packets coming a network
device go to a single network namespace we have to implement migration
for network devices.

Eric
