Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1GOWm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 18:42:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1GOWmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:42:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=R6jXXDNFemw5GeAp/a3iVLdrxRdgJRh4O52n+fcMyqhVRPm0IKPbtQdrznULDyfKL
	IWY+Xa9Uyr6JS9nFA4yzA==
MIME-Version: 1.0
In-Reply-To: <CABV1ukEF_VY-X5ZmBLoiCgNXg_KM06Y7duQQ-qyE0wdEc+eEJw@mail.gmail.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <1310675693-9204-2-git-send-email-mikew@google.com> <20110714234248.7ed43534@lxorguk.ukuu.org.uk>
 <CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
 <20110715000037.3fc1670a@lxorguk.ukuu.org.uk> <CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>
 <20110715003912.149dcedd@lxorguk.ukuu.org.uk> <CAGTjWtD+5cZxQiE+tikUyz2SNgm3bR95GE2veevEv15cPX1E9A@mail.gmail.com>
 <CAGTjWtAo8dE4ASWYPZ0QJdNg3jFzpO=QP4eT5P3mNakxKy-5+g@mail.gmail.com>
 <4E20839A.8060200@zytor.com> <CABV1ukEF_VY-X5ZmBLoiCgNXg_KM06Y7duQQ-qyE0wdEc+eEJw@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 15 Jul 2011 15:42:01 -0700
Message-ID: <CAGTjWtBUavDUMFoFAFGrUQ700U7YDUBQL_w5rezOsLhp3fjGzw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
To: "Andrew G. Morgan" <agm@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Klibc mailing list <klibc@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 3:30 PM, Andrew G. Morgan <agm@google.com> wrote:
> I'd put it in kinit too.
>
> I think you may have to think about the call_usermodehelper code, and
> you might want to look at dropping CAP_SYS_MODULE too.

Looks like usermodehelpers are configurable for both the inheritable
set and the bounding set via /proc/sys/kernel/usermodehelper/bset and
/proc/sys/kernel/usermodehelper/inheritable thanks to Eric Paris
(17f60a7da, available in 3.0-rc1).

>
> Cheers
>
> Andrew
>
> On Fri, Jul 15, 2011 at 11:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/15/2011 11:13 AM, Mike Waychison wrote:
>>>
>>> So the question is, should this go in the kernel proper such that it
>>> manipulates the init_cred structure, or should this be plumbed down in
>>> kinit (in klibc, which we use for bootup)?
>>>
>>
>> It certainly would be trivial to do in kinit.
>>
>>        -hpa
>>
>> --
>> H. Peter Anvin, Intel Open Source Technology Center
>> I work for Intel.  I don't speak on their behalf.
>>
>>
>
