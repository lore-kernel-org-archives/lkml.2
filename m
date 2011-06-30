Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab1F3U0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 16:26:31 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:59142 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751100Ab1F3U02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 16:26:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=T7J5yNmJgqI7JsVrT9WWgrdqqYOXLjDlyGjgIz68ceCNYlQhzQICskIPXxxF9mmJ2sRb5EQTtDc0cpvMeqtBeluWWlSampvPi6GPnaH1FOqiAffSsl+6vbV8W5C1Kz43;
Date: Thu, 30 Jun 2011 13:26:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Oliver Hartkopp <socketcan@hartkopp.net>,
        torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
Message-ID: <20110630132616.186f2e3f@jbarnes-desktop>
In-Reply-To: <CAErSpo6=c0C-+SbJjFPQFNM3u1pFNZ0TogcwB+takiprUpkM4w@mail.gmail.com>
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
	<4E0CACB7.7040709@hartkopp.net>
	<20110630100705.2d65656c@jbarnes-desktop>
	<4E0CAE86.6020901@hartkopp.net>
	<20110630183816.GA20268@ram-laptop>
	<CAErSpo6=c0C-+SbJjFPQFNM3u1pFNZ0TogcwB+takiprUpkM4w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 14:24:24 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Thu, Jun 30, 2011 at 12:38 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> > On Thu, Jun 30, 2011 at 07:12:38PM +0200, Oliver Hartkopp wrote:
> >> On 30.06.2011 19:07, Jesse Barnes wrote:
> >> > On Thu, 30 Jun 2011 19:04:55 +0200
> >> > Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> >> >
> >> >> On 30.06.2011 10:09, Ram Pai wrote:
> >> >>> Multiple attempts to dynamically reallocate pci resources have unfortunately
> >> >>> lead to regressions. Though we continue to fix the regressions and fine tune the
> >> >>> dynamic-reallocation behavior, we have not reached a acceptable state yet.
> >> >>>
> >> >>> This patch provides a interim solution. It disables dynamic-reallocation; by
> >> >>> default, with the ability to enable it through pci=realloc kernel command line
> >> >>> parameter.
> >> >>
> >> >> What is the advantage of creating an 'interim' kernel parameter instead of
> >> >> reverting the problematic commit and queue up a proper solution for 3.1 ?
> >> >>
> >> >> A kernel parameter needs to be observed, documented and set appropriately.
> >> >>
> >> >> I would prefer to have an automatic solution - if not in 3.0 then in 3.1 ...
> >> >
> >> > Yeah, we all want an automatic solution, but we still haven't been able
> >> > to achieve one.  My hope is that a parameter will let us keep the code
> >> > upstream for Ram and others to keep fixing, then we can move to using
> >> > it by default in some future release.  Keeping the code upstream but
> >> > behind a param should make development easier; at least that's the goal.
> >>
> >> What's wrong with the "[PATCH 0/4 v2] PCI: fix cardbus and sriov regressions"?
> >> To me it looked good - or don't you trust that fix right now?
> >
> > I trust the fix :).
> >
> > Linus's concern was the wrong alignment, which I have fixed, but yet to resend
> > the patchset. Will do today.
> >
> > However Linus's other concern was "too late for 3.0.0, for such a large patch".
> >
> > There is the other concern about "should cardbus resources be treated nice-to-have?"
> 
> Somewhere along the way, can we get rid of the awkward "nice-to-have"
> language?  I think "optional" conveys most of the intended meaning,
> perhaps lacking the shade that "we'll allocate them if we can."  But
> the important part is that they are not *required*, and "optional" is
> a nice antonym for "required."

I think there's a lot more that could be cleaned up in the re-alloc
code; e.g. add_head isn't very descriptive as a way to pass around
resources that we're tracking for potential re-allocation.

-- 
Jesse Barnes, Intel Open Source Technology Center
