Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab1F3UYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 16:24:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1F3UYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 16:24:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=OQsFKzNmFbX1CK1YRRse5mJUbO892jb8/YfS6YH51jZ9jxG1cnWepJCoyFZd8/Jos
	AmyPME/4t/u8eaatrIRhw==
MIME-Version: 1.0
In-Reply-To: <20110630183816.GA20268@ram-laptop>
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
 <4E0CACB7.7040709@hartkopp.net> <20110630100705.2d65656c@jbarnes-desktop>
 <4E0CAE86.6020901@hartkopp.net> <20110630183816.GA20268@ram-laptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 30 Jun 2011 14:24:24 -0600
Message-ID: <CAErSpo6=c0C-+SbJjFPQFNM3u1pFNZ0TogcwB+takiprUpkM4w@mail.gmail.com>
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
To: Ram Pai <linuxram@us.ibm.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:38 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Thu, Jun 30, 2011 at 07:12:38PM +0200, Oliver Hartkopp wrote:
>> On 30.06.2011 19:07, Jesse Barnes wrote:
>> > On Thu, 30 Jun 2011 19:04:55 +0200
>> > Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>> >
>> >> On 30.06.2011 10:09, Ram Pai wrote:
>> >>> Multiple attempts to dynamically reallocate pci resources have unfortunately
>> >>> lead to regressions. Though we continue to fix the regressions and fine tune the
>> >>> dynamic-reallocation behavior, we have not reached a acceptable state yet.
>> >>>
>> >>> This patch provides a interim solution. It disables dynamic-reallocation; by
>> >>> default, with the ability to enable it through pci=realloc kernel command line
>> >>> parameter.
>> >>
>> >> What is the advantage of creating an 'interim' kernel parameter instead of
>> >> reverting the problematic commit and queue up a proper solution for 3.1 ?
>> >>
>> >> A kernel parameter needs to be observed, documented and set appropriately.
>> >>
>> >> I would prefer to have an automatic solution - if not in 3.0 then in 3.1 ...
>> >
>> > Yeah, we all want an automatic solution, but we still haven't been able
>> > to achieve one.  My hope is that a parameter will let us keep the code
>> > upstream for Ram and others to keep fixing, then we can move to using
>> > it by default in some future release.  Keeping the code upstream but
>> > behind a param should make development easier; at least that's the goal.
>>
>> What's wrong with the "[PATCH 0/4 v2] PCI: fix cardbus and sriov regressions"?
>> To me it looked good - or don't you trust that fix right now?
>
> I trust the fix :).
>
> Linus's concern was the wrong alignment, which I have fixed, but yet to resend
> the patchset. Will do today.
>
> However Linus's other concern was "too late for 3.0.0, for such a large patch".
>
> There is the other concern about "should cardbus resources be treated nice-to-have?"

Somewhere along the way, can we get rid of the awkward "nice-to-have"
language?  I think "optional" conveys most of the intended meaning,
perhaps lacking the shade that "we'll allocate them if we can."  But
the important part is that they are not *required*, and "optional" is
a nice antonym for "required."

Bjorn
