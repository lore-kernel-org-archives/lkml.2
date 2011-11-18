Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1KRSpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:45:21 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49140 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1KRSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:45:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, richard@nod.at,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
References: <20111117045230.GA26345@hallyn.com>
	<m1aa7u2jv1.fsf@fess.ebiederm.org> <20111118173752.GB11823@sergelap>
Date: Fri, 18 Nov 2011 10:46:17 -0800
In-Reply-To: <20111118173752.GB11823@sergelap> (Serge E. Hallyn's message of
	"Fri, 18 Nov 2011 11:37:52 -0600")
Message-ID: <m14ny12rra.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19VuLTNxXdP3+TbtB1xLFE9WwdnR2GHB/w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge.hallyn@canonical.com>
X-Spam-Relay-Country: **
Subject: Re: user namespace: make signal.c respect user namespaces (v5)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge.hallyn@canonical.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> There is a small bug here.  You want to fixup q->info, not info.
>> Otherwise you might try dereferencing one of the special signals and get
>> a NULL pointer dereference.
>
> Thanks, Eric.  Oddly I've not seen this happen in quite a bit of
> testing with the kernel, but you certainly must be right.  I sent
> out a new patch to fix that.

You clearly have a different test case than I do.

I managed to trigger the oops  within about 5 minutes of just fooling
around.

You want to say &q->info not q->info in your updated patch.

Thanks,
Eric
