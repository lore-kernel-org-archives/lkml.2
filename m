Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab2LNSgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:36:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab2LNSgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:36:09 -0500
Message-ID: <50CB716D.6020501@zytor.com>
Date: Fri, 14 Dec 2012 10:35:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, Stefani Seibold <stefani@seibold.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        mingo@redhat.com, john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e> <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e> <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e> <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com> <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com> <50CA81A4.9040702@zytor.com> <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com> <50CA85BD.7070502@zytor.com> <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com> <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com> <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com> <50CAE485.5020608@parallels.com>
In-Reply-To: <50CAE485.5020608@parallels.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 12:34 AM, Pavel Emelyanov wrote:
> On 12/14/2012 06:20 AM, Andy Lutomirski wrote:
>> On Thu, Dec 13, 2012 at 6:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Wouldn't the vdso get mapped already and could be mremap()'d.  If we
>> really need more control I'd almost push for a device/filesystem node
>> that could be mmapped the usual way.
>>
>> Hmm.  That may work, but it'll still break ABI.  I'm not sure that
>> criu is stable enough yet that we should care.  Criu people?
> 
> It's not yet, but we'd still appreciate the criu-friendly vdso redesign.
> 
>> (In brief summary: how annoying would it be if the vdso was no longer
>> just a bunch of constant bytes that lived somewhere?)
> 
> It depends on what vdso is going to be. In the perfect case it should
> a) be mremap-able to any address (or be at fixed address _forever_, but
>    I assume this is not feasible);
> b) have entry points at fixed (or somehow movable) places.
> 
> I admit that I didn't understand your question properly, if I did,
> please correct me.
> 

mremap() should work.  At the same time, the code itself is not going to
have any stability guarantees between kernel versions -- it obviously
cannot.

Incidentally, the MAYWRITE bit which is there to allow breakpoints is
obviously problematic for the vvar page.  We could mark the vvar page
differently, meaning more vmas, or we could decide it just doesn't
matter and that if you mprotect() the vvar page and write to it you get
exactly what you asked for...

	-hpa


