Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2CHQcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:32:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45572 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2CHQcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:32:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fernando Luis =?utf-8?Q?V=C3=A1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org, vgoyal@redhat.com
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
	<20120216172735.GX9751@redhat.com>
	<CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com>
	<20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org>
	<m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com>
	<m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com>
	<m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com>
	<m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp>
	<4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org>
	<4F58495B.5080308@oss.ntt.co.jp>
Date: Thu, 08 Mar 2012 08:35:12 -0800
In-Reply-To: <4F58495B.5080308@oss.ntt.co.jp> ("Fernando Luis =?utf-8?Q?V?=
 =?utf-8?Q?=C3=A1zquez?= Cao"'s
	message of "Thu, 08 Mar 2012 14:53:31 +0900")
Message-ID: <m1r4x3yrsv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18jbdLmdTKyxRN0n5NQM7pjODBayA5K6N8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Fernando Luis V=c3=a1zquez Cao <fernando@oss.ntt.co.jp>?=
X-Spam-Relay-Country: **
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> writes:

>> Is just a jump and not a move followed by a jump still 10 bytes?
>> I hate to say it but I think this fails miserably for any exception
>> after a nmi.
>
> Thank you for the heads up! Actually, it was working for the
> exceptions after the nmi but with a corrupted esi (vector
> number). My original intention was to fill the empty space
> with nops but forgot to actually implement it... Sorry about
> that. Will fix for the next iteration.

Sound good, and thank you very much for tackling this.

>> I expect the simplest solution is to modify early_idt_handler to test
>> for vector == 2.
>
> That is precisely what I did on a previous version but that would
> involve using registers which need to be saved and restored and
> I wanted to avoid using the stack in the NMI path. We would also
> need to add a "pushq rsi " in early_idt_handlers which implies
> modifying "early_idt_handlers" definition in "segment.h".
>
> If you are OK with it I would like to go with the approach in
> the two patches I sent.

I am fine with your approach.  I suggest a big fat comment mentioning
the 10 byte requirement and the register requirement.

Neither one is locally obvious which makes it easy to goof when
modifying the code.

>> Doing something less brittle than:
>>> extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
>> in segment.h might be a good idea as well.
>
> Yes, I agree. I will give it some thought.

Eric
