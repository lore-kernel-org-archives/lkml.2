Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3AIAFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:05:14 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40416 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3AIAFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:05:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yinghai@kernel.org>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<20130107152622.GD3219@phenom.dumpdata.com>
	<CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	<87y5g4z7rp.fsf@xmission.com>
	<CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
	<CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
Date: Tue, 08 Jan 2013 16:04:52 -0800
In-Reply-To: <CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 8 Jan 2013 15:40:11 -0800")
Message-ID: <874nirz0ez.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/DLReH/Np7Kjo6eLn+kqJiSqerFVjV2mA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not enough ram for it
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Mon, Jan 7, 2013 at 7:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Jan 7, 2013 at 7:13 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> I meant we should detect failure to allocate bounce buffers in in
>>> swiotlb_init() instead of panicing.
>>>
>>> I meant swiotlb_map_single() should either panic or simply fail.
>>>
>>> If I have read lib/swiotlb.c correctly the only place we allocate a
>>> bounce buffer is in swiotlb_map_single.  If there are more places we can
>>> allocate bounce buffers those need to be handled as well.
>>
>> ok, will give it a try.
>
> please check if you are ok with attached.
>

It looks like the right direction.   Certainly enough to test and see if
the code will work.

I don't see the point of adding a nopanic case to the swiotlb
initialization.  That just looks like unnecessary complications.
Certainly a nopanic case implemented by passing a nopanic parameter
looks like the wrong way to go.  At most you want to return an error
code and do:

swiotlb_init()
{
	if (swiotlb_init_with_default_size() == -ENOMEM)
		panic("Cannot allocate SWIOTLB buffer");
}

The page freeing in swiotlb_init_with_tbl appears to be in the wrong
function.  I suggest looking at swiotlb_late_init which apparently is
allowed to fail for some ideas.

> looks like it need more change of lines.

The size of the change matters less than how clean and maintainable the
result is.  If done carefully I expect you can have net fewer lines but
not needing to handle the case when the swiotlb apis are unavailable.

Eric
