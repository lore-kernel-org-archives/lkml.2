Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab1E1Bnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 21:43:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56656 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab1E1Bnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 21:43:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
	<20110203020703.GB21603@redhat.com>
	<20110203135324.93BC.A69D9226@jp.fujitsu.com>
	<20110526131028.7052a893.akpm@linux-foundation.org>
Date: Fri, 27 May 2011 18:43:29 -0700
In-Reply-To: <20110526131028.7052a893.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 26 May 2011 13:10:28 -0700")
Message-ID: <m1k4db61mm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/+n0WSIvGVKEUEQ7xXXblZtosDrjLghGw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg hook into crash_kexec())
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu,  3 Feb 2011 13:53:01 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> > > I wrote why this is no good idea by another mail. Please see it.
>> > > Anyway you have a right to don't use this feature.
>> > > 
>> > 
>> > But you have not explained that why do you need to hook into crash_kexec()
>> > and you have also not explained why do you need to send out kdump_msg()
>> > notification if kdump is configured.
>> > 
>> > Some detailed explanation here would help.
>> 
>> Hi,
>> 
>> I send it you now :)
>> 
>
> What happened with this?  kexec-remove-kmsg_dump_kexec.patch has two acks
> and one unexplained nack :(

As I recall the nack was based on a theoretical use case, and a cleanup
of kmsg_dump to make it more robust which I don't believe has happened,
instead of something real.

My feel is that we should remove kmsg_dump and if a real use case comes
up reconsider it at that time.

I don't think anyone cares too strongly at the moment because the
features are not expected to be used in conjunction with each other, nor
even expected to be compiled into the same kernel.  However given that
they are not used to be used in conjunction with each other a call into
kmsg_dump from crash_kexec is really just cluttering the code for no
benefit to anyone.

I do believe kmsg_dump suffers from all of the same problems lkdtm
suffered from long ago which is it only works in a working kernel,
and it is unlikely to tell you anything on system failure.

Eric

