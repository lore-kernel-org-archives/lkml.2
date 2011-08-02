Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1HBVmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:42:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1HBVmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:42:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=k89QECKEUitP1qaiasJWaUy+DjpaDOrPA3bFL8SWb3VnrASarw7usMHyv2vxYOc/d
	x+vI0xvm+vbYRjY8S3lVg==
MIME-Version: 1.0
In-Reply-To: <20110802210912.GB20986@stro.at>
References: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com>
 <20110719203853.646.50974.stgit@mike2.sea.corp.google.com>
 <20110729204529.GB3207@stro.at> <CAGTjWtCYb0NOBFsMxWKWEwN-pdOD1fqimHco3nk_N-tKQvxdyQ@mail.gmail.com>
 <20110802210912.GB20986@stro.at>
From: Mike Waychison <mikew@google.com>
Date: Tue, 2 Aug 2011 14:42:11 -0700
Message-ID: <CAGTjWtAyCZ9fyBeEcsrSmpzK4Lgae5uyHCfO2LExeYLSrx+4jg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] run-init: Add drop_capabilities support.
To: Maximilian Attems <max@stro.at>
Cc: "Andrew G. Morgan" <agm@google.com>, Eric Northup <digitaleric@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 2:09 PM, Maximilian Attems <max@stro.at> wrote:
> On Fri, 29 Jul 2011, Mike Waychison wrote:
>
>> On Fri, Jul 29, 2011 at 1:45 PM, Maximilian Attems <max@stro.at> wrote:
>> > On Tue, 19 Jul 2011, Mike Waychison wrote:
>> >
>> >> This patch adds the ability to run-init to allow the dropping of
>> >> POSIX capabilities.
>> >>
>> >> This works by adding a "-d" flag to run-init, which takes a comma
>> >> separated list of capability names that should be dropped right before
>> >> exec'ing the real init binary.
>> >>
>> >> kinit is also modified by this change, such that it understands the same
>> >> argument when prepended with "drop_capabilities=" on the kernel command
>> >> line.
>> >>
>> >> When processing capabilities to drop, CAP_SETPCAP is special cased to be
>> >> dropped last, so that the order that capabilities are given does not
>> >> cause dropping of later enumerated capabilities to fail if it is listed
>> >> early on.
>> >>
>> >> Dropping of capabilities happens in three parts.  We explicitly drop the
>> >> capability from init's inherited, permitted and effective masks.  We
>> >> also drop the capability from the bounding set using PR_CAPBSET_DROP.
>> >> Lastly, if available, we drop the capabilities from the bset and
>> >> inheritted masks exposed at /proc/sys/kernel/usermodehelper if available
>> >> (introduced in v3.0.0).
>> >
>> > hmm as 3.0 is out, I don't think we need more backward compatibility.
>> > do you have a strong arg for it?
>> > especially since this is an *optional* calling arg I really don't see
>> > the need of that backward crap.
>>
>> I'd like to keep it for the time being. I'm still building both 2.6.34
>> and 2.6.39 kernels at the moment, though I can maintain these last few
>> compatibility bits in-house if that makes it easier for you.
>
> you include anyway linux/version.h, would build disabling help you?
> that way that macro doesn't need duplicating.
>

For correctness sake, I think it's still a runtime check thing
(consider the case of an image that is reused between kernel builds).

Reflecting on it a bit more though, I'd be okay if we removed the
version check altogether and just made it warn if the file isn't
present.
