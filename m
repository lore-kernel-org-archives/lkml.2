Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0CWWPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:15:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0CWWPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:15:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: 2.6.34-rc2 - crash on shutdown
Date: Tue, 23 Mar 2010 23:18:11 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Stephane Eranian <eranian@google.com>, David R <david@unsolicited.net>,
       linux-kernel@vger.kernel.org
References: <20100323090206.33932wop73sdefm6@unsolicited.net> <bd4cb8901003230631q22cdac6dg8011489b94c6d5e0@mail.gmail.com> <4BA8C7A4.8050502@ladisch.de>
In-Reply-To: <4BA8C7A4.8050502@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003232318.11332.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Clemens Ladisch wrote:
> Stephane Eranian wrote:
> > On Tue, Mar 23, 2010 at 1:02 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> > > The only pointer access in this function is cpuhw->amd_nb, but
> > > I don't see any obvious bugs.
> > 
> > I reported a problem with the AMD initialization just last week.
> > There is an issue with amd_pmu_cpu_online() which gets called
> > too early, and thus fails. That leaves some bogus state and causes
> > a crash in amd_pmu_cpu_offline().
> > 
> > I proposed a fix which was rejected. The alternative involves moving
> > some the of CPU initialization code (on AMD) to an earlier position,i.e.,
> > which would be executed before the CPU_STARTED notifier. Nobody
> > has proposed anything else so far.
> 
> I don't know about the early bootmem stuff, but regardless of this issue,
> if amd_pmu_cpu_online() can fail, then amd_pmu_cpu_offline() must be able
> to handle this without blowing up.  Something like this (untested):

I guess we handle that already:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a90110c61073eab95d1986322693c2b9a8a6a5f6

Rafael
