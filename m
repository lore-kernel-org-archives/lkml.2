Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1EQLtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:49:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38261 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab1EQLtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Jbuk5kf+FxnmjIXKKXkbdLt9X3UVdRud2e/SjIiILOXBwkw4Z8ErGOB4EScO1QB7ro
         x0Wr0XAEWXHsK8uFxzKtTtuySo+JydlS9yh1mpts5Sldu1oCuIqWpuAfqBwoEig57XeQ
         sjBsfEsIqHaJu0dscedWgUCGhN2PLwRXXl5qg=
MIME-Version: 1.0
In-Reply-To: <4DD2605A.90506@redhat.com>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
	<4DD19C81.8000902@zytor.com>
	<20110517070527.GD22305@elte.hu>
	<4DD23CB6.3050503@redhat.com>
	<20110517092903.GJ22093@elte.hu>
	<4DD2409F.4030800@redhat.com>
	<20110517104654.GN22093@elte.hu>
	<4DD25D29.9040008@redhat.com>
	<20110517113851.GD13475@elte.hu>
	<4DD25FA4.7030307@redhat.com>
	<4DD2605A.90506@redhat.com>
Date: Tue, 17 May 2011 14:49:20 +0300
X-Google-Sender-Auth: lcJ6pExs-_4Q0gH47iPDso7L-SA
Message-ID: <BANLkTimnE19+FryY6J86wWAdHErA4FouDQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 2:47 PM, Avi Kivity <avi@redhat.com> wrote:
> On 05/17/2011 02:44 PM, Avi Kivity wrote:
>>
>> On 05/17/2011 02:38 PM, Ingo Molnar wrote:
>>>
>>> >
>>> >  Depends if the guest uses a read-modify-write pattern or not.  We
>>> > could do it
>>> >  transparently in kvm.ko, since the real cr4 need not corresponds to
>>> > the guest
>>> >  notion (for example, we often set cr0.wp or cr0.ts even though the
>>> > guest
>>> >  wants them clear).
>>>
>>> Oh, being transparent is a nice touch when it comes to security measures
>>> (catching attackers who think there's no SMEP and such) - but that would
>>> need
>>> KVM support and a new ioctl to configure it, right?
>>
>> Yes.
>>
>
> btw, KVM support is required anyway, you can't set random bits in cr4 (from
> either the guest or host userspace) - kvm needs to understand them.

Yeah, I was wondering how the CR4 hack would actually enable
something. :-) Please CC me if you do add such an ioctl() and we'll
make the native KVM tool use it by default.

                        Pekka
