Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1CCJdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:33:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49286 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1CCJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:33:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: lucian.grijincu@gmail.com, adobriyan@gmail.com, tavi@cs.pub.ro,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
	<20110302.170644.58413369.davem@davemloft.net>
Date: Thu, 03 Mar 2011 01:33:43 -0800
In-Reply-To: <20110302.170644.58413369.davem@davemloft.net> (David Miller's
	message of "Wed, 02 Mar 2011 17:06:44 -0800 (PST)")
Message-ID: <m1zkpc1rbc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+9XwGhE2P5MeibFLHWhR041qzzxMXcuHQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: Re: RFC v1: sysctl: add sysctl header cookie, share tables between nets
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> Date: Fri, 25 Feb 2011 20:52:32 +0200
>
>> This is a new approach to the "share sysctl tables" RFC series I
>> posted earlier this month.
>
> I do not disagree conceptually with these changes from a networking
> perspective, but I am not a sysctl layer expert so I don't know if the
> generic sysctl bits are a good idea or not.

I may be missing something in these patches. I haven't had time to look
at this most recent batch carefully.  But from a 10,000 foot perspective I
have a problem with them.  With a handful of network devices the size of
the data structures is negligible.

Where problems show up is when you have a lot of sysctl entries for
devices and at that point we have much larger problems using the
sysctl data structures.  Today add/remove are big O(previous entries)
and I think even readdir suffers from non-scalable data structures.

There are other related issues that the sysctl data structures are not
optimized for use in /proc, and that sysctl uses so usable but on off
locking like mechanisms.

Changing things to make the sysctl users more dependent on the current
implement details of the sysctl data structures seems the exact
opposite of the direction we need to go to make the sysctl data structures
scale.

So until I can see a reason why we should save a few bytes at the cost
of greater future maintenance costs I'm not in favor of this patch set.

Eric
