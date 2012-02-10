Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab2BJPg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:36:58 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:39663 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755112Ab2BJPgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:36:55 -0500
Date: Fri, 10 Feb 2012 16:35:46 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/21] PCI: Fix cardbus bridge resources as optional size
 handling
Message-ID: <20120210153546.GA5109@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Yinghai Lu <yinghai@kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ram Pai <linuxram@us.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
 <1327140517-14811-19-git-send-email-yinghai@kernel.org>
 <20120127102311.6027ea2c@jbarnes-desktop>
 <CAE9FiQXQPFYU45rctaNX4kSqh7JGCnds8U-Bh1N93xVieuqz5Q@mail.gmail.com>
 <20120205215824.GA5071@comet.dominikbrodowski.net>
 <CAE9FiQXvU-GCDSVMGvUT23WMMVmbyHpQOApuAp5mV+=UOPf_1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXvU-GCDSVMGvUT23WMMVmbyHpQOApuAp5mV+=UOPf_1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 03:30:09PM -0800, Yinghai Lu wrote:
> On Sun, Feb 5, 2012 at 1:58 PM, Dominik Brodowski
> <linux@dominikbrodowski.net> wrote:
> > On Fri, Jan 27, 2012 at 01:37:44PM -0800, Yinghai Lu wrote:
> >> On Fri, Jan 27, 2012 at 10:23 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >> > On Sat, 21 Jan 2012 02:08:34 -0800
> >> > Yinghai Lu <yinghai@kernel.org> wrote:
> >> >
> >> >> We should not set the requested size to -2.
> >> >>
> >> >> that will confuse the resource list sorting with align when SIZEALIGN is used.
> >> >>
> >> >> Change to STARTALIGN and pass align from start.
> >> >>
> >> >> We are safe to do that just as we do that regular pci bridge.
> >> >>
> >> >> In the long run, we should just treat cardbus like regular pci bridge.
> >> >>
> >> >> Also fix when realloc is not passed, should keep the requested size.
> >> >>
> >> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> >
> >> > I'd like to see some testing on this one... Dominik?
> >>
> >> Dominik,
> >>
> >> Can you please test branch at
> >>
> >>       git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> >> for-pci2
> >
> > Tested this on my limited test systems (COUNT=1), and seems to work fine.
> >
> 
> Thanks a lot.
> 
> Thought that you should have bunch of systems (laptop) with pci cardbus
> slots.
> 
> Found another regression by one commit already got into linus' tree.
> 
> and should be fixed by
> 
> [PATCH] pci: Fix pci cardbus removal
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=patch;h=29834f2faeed3cb87dea984a3d411337752e6b7c
> 
> please double check
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci3
> 
> or
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-busn-alloc

I pulled both trees, and things still work fine on my test system.

Best,
	Dominik
