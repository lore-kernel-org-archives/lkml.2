Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0ENBXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 21:23:18 -0400
Received: from mail.atheros.com ([12.36.123.2]:55304 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab0ENBXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 21:23:16 -0400
Date: Thu, 13 May 2010 18:23:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Bruno Randolf <br1@einfach.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Message-ID: <20100514012314.GA2170@tux>
References: <4BEC7A84.3010503@gmail.com>
 <AANLkTinKoMxdkPYQA_AblpByL6zAiAP5hv2M3Jn2R3hM@mail.gmail.com>
 <4BEC9E6B.30809@gmail.com>
 <201005141008.20667.br1@einfach.org>
 <4BECA3AE.4070607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BECA3AE.4070607@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 06:13:18PM -0700, Justin P. Mattock wrote:
> On 05/13/10 18:08, Bruno Randolf wrote:
> > On Friday 14 May 2010 09:50:51 Justin P. Mattock wrote:
> >> On 05/13/10 17:28, Luis R. Rodriguez wrote:
> >>> On Thu, May 13, 2010 at 5:21 PM, Justin P. Mattock
> >>>
> >>> <justinmattock@gmail.com>   wrote:
> >>>> On 05/13/10 16:01, Luis R. Rodriguez wrote:
> >>>>> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
> >>>>>
> >>>>> <justinmattock@gmail.com>     wrote:
> >>>>>> not sure what this is, but while at a convention
> >>>>>> I was trying to access the internet and(below is
> >>>>>> full dmesg) this showed up.
> >>>>>>
> >>>>>> After receiving this, I sat and tried to re-create
> >>>>>> my steps to reproduce but had no luck(was even going
> >>>>>> todo a bisect n the spot if I could re-create).
> >>>>>
> >>>>> OK this stuff is hard to reproduce it seems.. you have an Atheros
> >>>>> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
> >>>>> to get the poison stuff? I am just surprised we haven't seen it
> >>>>> ourselves yet. Let me make sure all of us get this kconfig option
> >>>>> enabled.
> >>>>>
> >>>>>     Luis
> >>>>
> >>>> CONFIG_ATH_COMMON=m
> >>>> # CONFIG_ATH_DEBUG is not set
> >>>> CONFIG_ATH5K=m
> >>>> # CONFIG_ATH5K_DEBUG is not set
> >>>> CONFIG_ATH9K_HW=m
> >>>> CONFIG_ATH9K_COMMON=m
> >>>> CONFIG_ATH9K=m
> >>>> # CONFIG_ATH9K_DEBUGFS is not set
> >>>>
> >>>> if you need my .config let me know.
> >>>> (I can try again reproducing, but man
> >>>> just doesn't easily fire off).
> >>>
> >>> Oh I mean the config options to enable the poison rant.
> >>>
> >>>     Luis
> >>
> >> shoot.. not sure how to grep for the right info
> >> in the .config for you, heres what grepping for COFIG_DEBUG
> >> looks like:
> >> CONFIG_DEBUG_FS=y
> >> CONFIG_DEBUG_KERNEL=y
> >> CONFIG_DEBUG_RT_MUTEXES=y
> >> CONFIG_DEBUG_PI_LIST=y
> >> CONFIG_DEBUG_SPINLOCK=y
> >> CONFIG_DEBUG_MUTEXES=y
> >> CONFIG_DEBUG_BUGVERBOSE=y
> >> CONFIG_DEBUG_MEMORY_INIT=y
> >> CONFIG_DEBUG_STACKOVERFLOW=y
> >
> > oh, this reminds me of a similar report we had for ath5k:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=15861
> >
> > the subject on this mailing list was "ath5k misbehaving affecting other kernel
> > parts unrelated?"
> >
> > bruno
> >
> 
> Could be.. From what I remember
> all I was doing was switching from
> one wireless network to another
> (then opening firefox to sign my life away).

Were you using network-manager? Or the supplicant manually?

  Luis
