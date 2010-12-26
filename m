Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0LZMF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 07:05:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0LZMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 07:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=I3PZYv74SEajrpbmHSEld3t7C9e7ubncV04z8+bN5wc/O2VeL2z/E/By8QSVfwHJuA
         m5DWxBXboGeLPMAouTZX2k22UD9LQbdhcEle7O8BArtr3OIC7ym/iw0Xv2hnO1QBi3FM
         auCOoOSu9egEmCtek7pj/qE0ro5h1woWdC1co=
MIME-Version: 1.0
In-Reply-To: <AANLkTinNhupY59gYJNi_za8UvgGkjFA9mbdkKfwfKWeQ@mail.gmail.com>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<AANLkTi==ahwQXGK-hPq+2KVRRwQiL9j7vVakAwi=NTiq@mail.gmail.com>
	<AANLkTinye4NY6D=pHWRKTW=smhS3qg1kfBW7wncQgXSU@mail.gmail.com>
	<AANLkTinNhupY59gYJNi_za8UvgGkjFA9mbdkKfwfKWeQ@mail.gmail.com>
Date: Sun, 26 Dec 2010 20:05:57 +0800
Message-ID: <AANLkTi=FOz1UZw8pbYA7Tb7b1q4O1=WRL3fzOuN0E0wX@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 5:08 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Sun, Dec 26, 2010 at 1:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Sun, Dec 26, 2010 at 2:46 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>> On Sun, Dec 26, 2010 at 11:13 AM, Hillf Danton <dhillf@gmail.com> wrote:
>>> Above description tells how its done, what it is but its not clear why
>>> we should use it. Can I know why should we use it or its benefits?
>>>
>>
>> The outstanding benefit looks that nano semaphore could be used in
>> cases where callers want to wait not only more than one jiffy, but far
>> less than one jiffy also.
>>
> But, how do we know that resources are going to be available within
> one jiffy or far less than one jiffy? We we be deterministic?
>
This is a really hard question.

Though I could not answer as fine as Ingo Molnar could, the
deterministic has to be faced by most contentions for resources in
kernel, simply because deadlock could occur in spin lock for instance.

On the other hand, this question explores a byproduct advantage, not
seriously considered before,  of nano semaphore, that the caller could
learn that there is something out of track if she waited over 100
microseconds in 5 consequent steps, 20 microseconds a step, if she
think the resource should be available in 60 microseconds.

And in nano semaphore method is available for callers to select
waiting over one second, one millisecond, one microsecond, one
nanosecond, depending on what the underlying system could offer. After
waiting, the caller is free to determine what to do next if the
resource is not available.

Here is another sample, if taxi will not come in two minutes, I could
either give up shopping downtown, or wait another three minutes,
depending on what will happen two minutes later.

thanks
Hillf
