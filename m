Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2AYFel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:34:41 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40032 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab2AYFek convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:34:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120121173207.GF3821@phenom.ffwll.local>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
 <1326845297-6233-1-git-send-email-rmorell@nvidia.com> <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
 <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
 <20120120180457.GE29824@morell.nvidia.com> <20120121173207.GF3821@phenom.ffwll.local>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 25 Jan 2012 11:04:18 +0530
Message-ID: <CAB2ybb8YepvuKDAMBH1REYERuajmczHZvsv=ENX0SFcuagXm=Q@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
To: Robert Morell <rmorell@nvidia.com>, "Semwal, Sumit" <sumit.semwal@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 11:02 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Fri, Jan 20, 2012 at 10:04:57AM -0800, Robert Morell wrote:
>> On Wed, Jan 18, 2012 at 01:10:04AM -0800, Semwal, Sumit wrote:
>> > On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
>> > > EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
>> > > issue, and not really an interface".  The dma-buf infrastructure is
>> > > explicitly intended as an interface between modules/drivers, so it
>> > > should use EXPORT_SYMBOL instead.
>> >
>> > + Konrad, Arnd, Mauro: there were strong objections on using
>> > EXPORT_SYMBOL in place of EXPORT_SYMBOL_GPL by all 3 of them; I
>> > suggest we first arrive at a consensus before merging this patch.
>>
>> This discussion seems to have stagnated; how do we move forward here?
>>
>> Sumit, as the primary author and new maintainer (congrats!) of the
>> dma-buf infrastructure, it seems like it's really your call how to
>> proceed.  I'd still like to see this be something that we can use from
>> the nvidia and fglrx drivers for Xorg buffer sharing, as I and Dave have
>> argued in this thread.  It really seems to me that this change on a
>> technical level won't have any adverse effect on the scenarios where it
>> can be used today, but it will allow it to be used more widely, which
>> will prevent duplication and fragmentation in the future and be greatly
>> appreciated by users of hardware such as Optimus.
>
> Given that I've participated quite a bit in the design of dma_buf as-is,
> let me throw in my totally irrelevant opinion, too ;-)
>
> I'll refrain from comment on the actual patch, it's obviously a hot topic.
> Furthermore I might need to ask Intel's legal dep for guidance to asses
> things wrt my own contributions to dma_buf.
>
> Otoh I'd like nvidia to be on board, especially when we're desingned
> additions to dma_buf required to make it really work for multiple gpus. In
> additions it looks like that the nvidia blob will only be an importer of a
> dma_buf, at least for the use-cases discussed here.
>
> So why don't you just ditch this patch here and add a small shim to your
> blob to interface with drm's prime as an importing driver? I personally
> would deem that acceptable and I think Dave wouldn't mind too much,
> either.

Hi Everyone!

(Apologies for delay in replying; was OoO for past couple of days)

Thanks very much for this discussion - a couple of things:

1. I am definitely willing to make changes as needed to get as many
devices / subsystems / frameworks to use the dma-buf infrastructure.
This could include changing the way symbols are exported, if that is
the *only* way to get things done.

2. With that premise, I quite like the idea that Daniel gave (of
course, in his capacity as one of the top contributors behind dma-buf
infrastructure, and like he said, not as an Intel employee) - so let
me ask the following:

Robert, Dave,
Technically speaking, is there no way that the EXPORT_SYMBOL_GPLed
symbols can be used by the binary blobs, possibly with an open-sourced
shim which provides the buffer-sharing interface to the binary blobs?
Are there any reasons to not consider this approach?

Also, if some of you are going to be at ELC mid-Feb at SFO, we could
meet up face-to-face and thrash out possible ways forward.
>
> Yours, Daniel
Thanks, and best regards,
~Sumit.
>
> Disclaimer: This is my own opinion and I do not speak as an Intel employee
> here.
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
