Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab0JGOLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:11:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0JGOLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d5S5hQpnUw3D4YeEvomvaaSKTItfUB5JtF3GmySLbc26Qj6ZsbPWSer3BZYVRzzIl1
         bv35VFjqJ+67sfYgFBnw==
MIME-Version: 1.0
In-Reply-To: <4CADD257.7080203@zytor.com>
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
Date: Thu, 7 Oct 2010 16:11:42 +0200
Message-ID: <AANLkTin+PXzz4qJHX6kHiQW8Rqdrv=hrvq4iWuaOnGiV@mail.gmail.com>
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

On Thu, Oct 7, 2010 at 3:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/07/2010 03:46 AM, Stephane Eranian wrote:
>>
>> As for the patch itself, I am not an expert at xsave/xrstor, but it seems to
>> me you could decouple LWP from FPU. I think  Brian had the same comment.
>> I suspect this can be done and it will certainly look cleaner.
>>
>
> Well, once you're using XSAVE you're not decoupled from the FPU.  Worse,
> if you're using XSAVE and not honoring CR0.TS you have a major design flaw.
>
Is that to say, that if you use LWP you will have to save/restore FPU state even
though you're not actually using it?

> Nothing that can't be dealt with, but still...
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>
