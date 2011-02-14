Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab1BNSHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48762 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1BNSHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UwkxMyj8mXNqjR74+jQUaRqP+in58d3QaxCn46WbT7/Psc55MTLx/T6kwOieE1dtU9
         NDbfJv32L2wrvZqlaFFAZO/cadDYPkS0GRVcRux7+MKNexvIApKEerafk6cKYIzCsOGh
         SIHgj8K+w4cvvVSIGY/i1rjK7WFUwF8fd6p4s=
MIME-Version: 1.0
In-Reply-To: <AANLkTin-i3+Pw8gW8c9AM2+6H1SsUgtqjvAYEv3Mi3HQ@mail.gmail.com>
References: <20110207180606.GB2966@flint.arm.linux.org.uk>
	<AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com>
	<20110208125546.GA4286@flint.arm.linux.org.uk>
	<alpine.DEB.2.00.1102080856020.12521@router.home>
	<AANLkTimFDZFcO=J6PEOOo5RBdr0m7fjCKzWh1M_NaiLx@mail.gmail.com>
	<20110211091413.GA32687@flint.arm.linux.org.uk>
	<alpine.DEB.2.00.1102110920060.12360@router.home>
	<20110211153524.GB26188@flint.arm.linux.org.uk>
	<AANLkTimDUf52xdHn22=f1J=Xn88sqPEg9P6+ceas1h1k@mail.gmail.com>
	<20110214154011.GA1595@flint.arm.linux.org.uk>
	<AANLkTin-i3+Pw8gW8c9AM2+6H1SsUgtqjvAYEv3Mi3HQ@mail.gmail.com>
Date: Mon, 14 Feb 2011 20:07:05 +0200
X-Google-Sender-Auth: x4QKZR4nLK2pnPNuQQKZAUEAhOM
Message-ID: <AANLkTinauvqVun_EZuXhBKa3ZyMwASf4E1-Qc9YAn9o2@mail.gmail.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
From: Pekka Enberg <penberg@kernel.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: ShiYong LI <a22381@motorola.com>, Christoph Lameter <cl@linux.com>,
        Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 5:43 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, Feb 14, 2011 at 5:40 PM, Russell King <rmk@arm.linux.org.uk> wrote:
>> Mainline only supports 32 byte and 64 byte cache lines on ARM.  It does
>> not support 128 byte cache lines, so maybe your attempts are the wrong
>> approach.  Can you please post your 128 byte cache line support patches
>> to the ARM kernel mailing list for review.
>>
>> In the mean time, because your patch causes an oopsing regression, I
>> strongly suggest that it is reverted until we start supporting 128 byte
>> cache lines on ARM in mainline.
>
> Agreed. I'll queue a revert. Thanks, Russell!

It's this commit queued for linux-next:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commit;h=3ff84a7f36554b257cd57325b1a7c1fa4b49fbe3
