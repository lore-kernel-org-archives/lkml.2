Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0LRG6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 01:58:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53334 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0LRG6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 01:58:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: kirill@shutemov.name, netdev@vger.kernel.org, pablo@netfilter.org,
        ldv@altlinux.org, linux-kernel@vger.kernel.org
References: <1292259913-9911-1-git-send-email-kirill@shutemov.name>
	<m1sjy1uzj6.fsf@fess.ebiederm.org>
	<20101217.120234.59681524.davem@davemloft.net>
Date: Fri, 17 Dec 2010 22:58:01 -0800
In-Reply-To: <20101217.120234.59681524.davem@davemloft.net> (David Miller's
	message of "Fri, 17 Dec 2010 12:02:34 -0800 (PST)")
Message-ID: <m1oc8jlg92.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18wW3XN0qZ6E3kKpprmD5qK2sg/4ne6ESE=
X-SA-Exim-Connect-IP: 98.207.157.188
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
Subject: Re: [PATCH] netlink: fix gcc -Wconversion compilation warning
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Mon, 13 Dec 2010 13:35:25 -0800
>
>> "Kirill A. Shutsemov" <kirill@shutemov.name> writes:
>> 
>>> From: Dmitry V. Levin <ldv@altlinux.org>
>>>
>>> $ cat << EOF | gcc -Wconversion -xc -S -o/dev/null -
>>> unsigned f(void) {return NLMSG_HDRLEN;}
>>> EOF
>>> <stdin>: In function 'f':
>>> <stdin>:3:26: warning: negative integer implicitly converted to unsigned type
>>>
>> This doesn't look like a bad fix, but I believe things will fail if
>> we give NLMSG_ALIGN an unsigned long like size_t.  Say like sizeof.
>
> What are you talking about? That's exactly his test case,
> look at what NLMSG_HDRLEN is defined to, it's exactly the
> case you're worried "will fail", it passes sizeof() to
> NLMSG_ALIGN.
>
> I think I'll apply Kirill's original patch, it's good enough
> and simpler.

Probably.  The case I was worried about was masks that become
0xffffffxx on 64bit instead of 0xffffffffffffxx.  Especially
when mixing those with ints.

It is possible to get some really weird things.

Eric
