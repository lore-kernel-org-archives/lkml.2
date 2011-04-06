Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047Ab1DFEeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 00:34:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54116 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab1DFEeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 00:34:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
Date: Wed, 6 Apr 2011 06:34:12 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <201104050843.39246.rjw@sisk.pl> <4D9BA9FA.4010405@zytor.com>
In-Reply-To: <4D9BA9FA.4010405@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201104060634.12555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 06, 2011, H. Peter Anvin wrote:
> On 04/04/2011 11:43 PM, Rafael J. Wysocki wrote:
> > On Tuesday, April 05, 2011, H. Peter Anvin wrote:
> >> On 04/04/2011 11:29 PM, Rafael J. Wysocki wrote:
> >>>>
> >>>> Peter very consciously did not mark the fix for this commit as -stable 
> >>>> material. It was ineligible for -stable for multiple reasons: it by no means 
> >>>> fixed a 2.6.39 regression and the fix was literally just a few days old.
> >>>
> >>> Has this issue been resolved in the mainline, BTW?
> >>>
> >>
> >> Just to refresh my memory... is this an issue in mainline, or is it only
> >> a problem in the backport (I'm wondering if the trampoline unification
> >> patches might have accidentally solved the issue)?
> > 
> > 
> > The problem is in mainline too, please fix ASAP.
> > 
> 
> For the suspend/resume case this seems like the sanest way to fix it in
> my opinion.  However, I am a bit concerned since I'm still not sure
> we're programming registers in the correct order, that is:
> 
> MISC_ENABLE -> EFER -> cr4 -> cr3 -> cr0
> 
> I will look at this issue later this evening, but I wanted your opinion
> on it.

Do you mean during resume?

I think we can try to make the ordering more appropriate, but I'm not really
sure it would be a good idea to do that in the same patch.  Probably not.

Also, our current ordering has never been reported to cause problems to anyone.

Thanks,
Rafael
