Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab1LGXaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:30:19 -0500
Received: from lo.gmane.org ([80.91.229.12]:36336 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab1LGXaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:30:17 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Peter Kolta <peterkolta63@gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of worrying about possible misusage?
Date: Wed, 7 Dec 2011 23:24:31 +0000 (UTC)
Message-ID: <loom.20111208T001039-201@post.gmane.org>
References: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk> <4EDE0427.2050307@linuxtv.org> <20111206141929.GE17731@opensource.wolfsonmicro.com> <4EDE2B3B.2080905@linuxtv.org> <20111207134848.GB18837@opensource.wolfsonmicro.com> <4EDF71AE.5070509@linuxtv.org> <4EDFDF3F.8020202@gmail.com> <CAJbz7-1F_rrPAEh7+eGUUwbNDkWu4g857kA=uQwZBb-snp590w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 114.24.65.232 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Ubuntu/11.10 Chromium/14.0.835.202 Chrome/14.0.835.202 Safari/535.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Honza Petrouš <jpetrous <at> gmail.com> writes:

> 
> 2011/12/7 Patrick Dickey <pdickeybeta <at> gmail.com>:
> > On 12/07/2011 08:01 AM, Andreas Oberritter wrote:
> >> On 07.12.2011 14:49, Mark Brown wrote:
> >>> On Tue, Dec 06, 2011 at 03:48:27PM +0100, Andreas Oberritter wrote:
> >>>> On 06.12.2011 15:19, Mark Brown wrote:
> >>>
> > I tend to stay out of these discussions, since like a couple of others,
> > I'm not a kernel developer (or hacker). However, I wanted to chime in
> > with my two cents here.
> >
> > 1.  I agree that it's not acceptable to "NACK" purely for philosophical
> > reasons (except when it's a clear violation of a license--be that open
> > source or closed source (since we don't want to open ourselves up to
> > lawsuits).
> >
> > 2.  In this case, there have been technical reasons provided. Granted
> > the developers (and people who are pro-inclusion) don't feel those are
> > justified, but they have been cited.
> >
> > 3.  You'll catch more flies with honey than vinegar (in other words,
> > fighting with the person(s) who maintain the project will most
> > definitely *not* get your code included).
> 
> Yes, that I think we all know. But some problem is that the arguments
> against it are very weak. Believe me I would prefer to work on all
> hints which kernel hackers gave me after code reviewing and not
> to be member of flamewar.
> 

I took the time and went through this thread.
I like the idea of supporting the device via network, but I do not like the idea 
of having a virtual driver and server separate for this.
Before adding this hackish approach you can do a better design at early stages 
right now.

Why can't you just patch the necessary functions of the applications which you 
pointed out to access a library? This would totally eliminate the need of the 
kernel module. It would greatly enhance the usability of this feature.

> Some features are designed for LAN use. I think nobody wants to use
> SMBFS over Internet. But in LAN it works perfectly stable.
> 

SMBFS does not need to deliver data at a constant bitrate, several companies are 
doing that via VPNs.
> 
> As you stated already - maintaining kernel-space code out of kernel
> tree is much difficult. If anybody did any change in internal API, then
> you have to catch it yourself, find the way to change your code
> accordingly. If it would be in kernel, then such job is required to be
> done by patch contributor.
> 

I would not support this attempt, since right now you can do it a better way.
You even named it, streamdev for vdr why don't you improve it?
If you add some transcoding functionality to your idea you can do it all on 
application level and even stream it to the internet.
The virtual device seems to be a dead end for me which makes all those things 
more complicated in the end.

Peter

