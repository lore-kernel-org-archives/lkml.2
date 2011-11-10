Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935399Ab1KJQGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:06:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935224Ab1KJQGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:06:15 -0500
Date: Thu, 10 Nov 2011 17:07:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111110160703.GA2775@redhat.com>
References: <20111029171554.GA16596@nomi.cz>
 <20111031160342.GB2225@redhat.com>
 <20111109155411.GA1669@nomi.cz>
 <20111109165158.GA2254@redhat.com>
 <20111110091816.GA2247@nomi.cz>
 <20111110114732.GA2217@redhat.com>
 <20111110125347.GA29415@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110125347.GA29415@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 01:53:47PM +0100, Tomáš Janoušek wrote:
> > If "dmesg | grep corrupt" will show "Setting corrupt debug order to 1"
> > patches are in use. Anyway I need to test the patches locally, to see
> > if they work as expected, perhaps exception is generated but call-trace
> > is not printed.
> 
> It does say that, yes.

I tested patches. They generate call-trace and make kernel panic when I
wrote at random address from user address space. However to make kernel
panic, we should keep as much as possible free memory, otherwise bad code
corrupt not-protected data. In other words, when you run memory intensive
application, corruption may happen on valid data.  So to catch the bug,
you should just use network, and perhaps stress up cpu i.e: by this bash
command:

while true; do : ; done 

Please also configure CONFIG_DEBUG_SET_MODULE_RONX=y, it protect modules
text/read-only memory against corruption.

> > Is this happen only with "Intel Corporation Centrino Advanced-N 6205" or
> > with some other adapters?
> 
> I don't have any other iwlwifi adapters, so I wouldn't know. The people in
> that Ubuntu bugreport have exactly that card as well, but in another notebook.
> And they claim it works in newer Ubuntu, but I am running latest kernels with
> latest uCode, so I'm out of ideas what else could be wrong.

That's good hint for Intel folks. Would be ideal if any developer could
reproduce that. I do not have this exact adapter model.

> > > Perhaps it would be cheaper to just get another card in that case.
> > > :-)
> >
> > That will left issue unresolved :-(
> 
> Yeah, but considering how few people report this, I'm starting to feel that it
> might in fact be a hardware issue.

It's possible, but I don think so. In my practice, majority of corruption
problems was caused by software. All true hardware corruptions I meet, was on
development boards, many months before they went into production.

> (We've got a lot of Lenovos here, mostly T520 and T420s, most of them running
> Fedora, and nobody has reported memory corruption problems.

Are there any others with 6205? If not that would confirm issue is
related with that model.

> Perhaps I should try to connect to this WPA Enterprise using Windows and see
> if anything goes wrong. However, I have no clue as to what shall I do to
> reproduce the issue in Windows.)

You may first try some older kernel as Wey suggested, i.e. 2.6.38.

Thanks
Stanislaw
