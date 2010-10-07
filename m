Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0JGOZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:25:32 -0400
Received: from smtp-out.google.com ([74.125.121.35]:62978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0JGOZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JO/yM9dUJYEWpzVQT2nsrZHh/ZyrwYSNCUd1j9gWmButf+b+zSOLU9gW3EO6Bsx5po
         QnvrMvn5wf0emnDGESyQ==
MIME-Version: 1.0
In-Reply-To: <4CADD73B.8070809@zytor.com>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
	<alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
	<20101005145155.GD173@escobedo.osrc.amd.com>
	<alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
	<20101005182739.GE173@escobedo.osrc.amd.com>
	<20101005190501.GA21916@elte.hu>
	<20101006073558.GJ13563@erda.amd.com>
	<AANLkTi=T0QmcKeZcgcR+GKk-9OwQUB_x8XdHiNuU7tE_@mail.gmail.com>
	<AANLkTimwVuosF24_gBOTpMydfcj-SQPFyZM4uu=vEPbL@mail.gmail.com>
	<4CADD257.7080203@zytor.com>
	<AANLkTin+PXzz4qJHX6kHiQW8Rqdrv=hrvq4iWuaOnGiV@mail.gmail.com>
	<4CADD73B.8070809@zytor.com>
Date: Thu, 7 Oct 2010 16:25:24 +0200
Message-ID: <AANLkTi=nTUvcmk1XBHx=Dp6Qqiksq=m_RDn96y1J+Mck@mail.gmail.com>
Subject: Re: [RFC 0/3] Basic support for LWP
From: Stephane Eranian <eranian@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, Hans.Rosenfeld@amd.com, robert.richter@amd.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Andreas.Herrmann3@amd.com, peterz@infradead.org, fweisbec@gmail.com,
        rostedt@goodmis.org, acme@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 4:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/07/2010 07:11 AM, Stephane Eranian wrote:
>> On Thu, Oct 7, 2010 at 3:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 10/07/2010 03:46 AM, Stephane Eranian wrote:
>>>>
>>>> As for the patch itself, I am not an expert at xsave/xrstor, but it seems to
>>>> me you could decouple LWP from FPU. I think  Brian had the same comment.
>>>> I suspect this can be done and it will certainly look cleaner.
>>>>
>>>
>>> Well, once you're using XSAVE you're not decoupled from the FPU.  Worse,
>>> if you're using XSAVE and not honoring CR0.TS you have a major design flaw.
>>>
>> Is that to say, that if you use LWP you will have to save/restore FPU state even
>> though you're not actually using it?
>>
>
> No, but you wouldn't be able to use lazy FPU.
>
You mean lazy restore, I am guessing here.
Is that to say, you cannot figure out whether the FPU state in
the CPU on ctxsw in is yours anymore?

>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>
