Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2BPVrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:47:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab2BPVrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:47:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: Corrupted files after suspend to disk
Date: Thu, 16 Feb 2012 22:51:46 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, esandeen@redhat.com
References: <AANLkTinRC1hXvaXDVV5pOA4YyCdXwAjziZsDzm=LuHqK@mail.gmail.com> <CAFLxGvzzHDRma_Y_XEpOD+fY+vonbkoR1mvQp4Vb4c3M6fTsPA@mail.gmail.com> <20120216163030.GA32651@redhat.com>
In-Reply-To: <20120216163030.GA32651@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202162251.47063.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 16, 2012, Dave Jones wrote:
> On Thu, Feb 16, 2012 at 11:52:27AM +0100, richard -rw- weinberger wrote:
>  
>  > >> >> Of course, please test the above separately. :-)
>  > >> >
>  > >> > Ok, I'll test this when I'm at home.
>  > >> >
>  > >> > BTW: dropping the caches helps, when some files seem corrupted.
>  > >> > Today /usr/bin/okular was broken.
>  > >> > After setting vm.drop_caches=1 it worked again.
>  > >>
>  > >> On Linux 2.6.38 I'm unable to reproduce the issue.
>  > >> Only 2.6.37 seems to be affected.
>  > >> So, I'm moving over to 2.6.38. :)
>  > >
>  > Bad news:
>  > I saw the issue on 3.x too but thought it's because my IdeaPad s10 is crap.
>  > Now with my shiny new Lenovo x121e I have the same issue! :-(
>  > 
>  > OpenSUSE 12.1, kernel 3.2.7.
>  > After a few suspend2disk iterations random files are corrupted.
>  > But only cached files. A reboot solves the problem.
>  
> FWIW, we've been seeing a number of hard to diagnose failures
> with suspend to disk for the last few releases in Fedora.
> Eric Sandeen has been chasing https://bugzilla.redhat.com/show_bug.cgi?id=744275
> for a while, but there's no smoking gun that really explains what's
> getting into these states. Further complicating things, is that it
> doesn't seem to be 100% reproducable.

I wonder if that's reproducible with the filesystems freezing patch I posted
some time ago (it will need some rebasing to apply to the current mainline or
3.2.y).

I also thing that this problem discovered by Alan Stern may be involved:

http://marc.info/?l=linux-pm&m=132940331030253&w=4

Thanks,
Rafael
