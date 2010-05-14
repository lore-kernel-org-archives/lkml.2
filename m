Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0ENBPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 21:15:21 -0400
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:5425 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754052Ab0ENBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 21:15:20 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2010 21:15:19 EDT
From: Bruno Randolf <br1@einfach.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Date: Fri, 14 May 2010 10:08:20 +0900
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4BEC7A84.3010503@gmail.com> <AANLkTinKoMxdkPYQA_AblpByL6zAiAP5hv2M3Jn2R3hM@mail.gmail.com> <4BEC9E6B.30809@gmail.com>
In-Reply-To: <4BEC9E6B.30809@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005141008.20667.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010 09:50:51 Justin P. Mattock wrote:
> On 05/13/10 17:28, Luis R. Rodriguez wrote:
> > On Thu, May 13, 2010 at 5:21 PM, Justin P. Mattock
> > 
> > <justinmattock@gmail.com>  wrote:
> >> On 05/13/10 16:01, Luis R. Rodriguez wrote:
> >>> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
> >>> 
> >>> <justinmattock@gmail.com>    wrote:
> >>>> not sure what this is, but while at a convention
> >>>> I was trying to access the internet and(below is
> >>>> full dmesg) this showed up.
> >>>> 
> >>>> After receiving this, I sat and tried to re-create
> >>>> my steps to reproduce but had no luck(was even going
> >>>> todo a bisect n the spot if I could re-create).
> >>> 
> >>> OK this stuff is hard to reproduce it seems.. you have an Atheros
> >>> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
> >>> to get the poison stuff? I am just surprised we haven't seen it
> >>> ourselves yet. Let me make sure all of us get this kconfig option
> >>> enabled.
> >>> 
> >>>    Luis
> >> 
> >> CONFIG_ATH_COMMON=m
> >> # CONFIG_ATH_DEBUG is not set
> >> CONFIG_ATH5K=m
> >> # CONFIG_ATH5K_DEBUG is not set
> >> CONFIG_ATH9K_HW=m
> >> CONFIG_ATH9K_COMMON=m
> >> CONFIG_ATH9K=m
> >> # CONFIG_ATH9K_DEBUGFS is not set
> >> 
> >> if you need my .config let me know.
> >> (I can try again reproducing, but man
> >> just doesn't easily fire off).
> > 
> > Oh I mean the config options to enable the poison rant.
> > 
> >    Luis
> 
> shoot.. not sure how to grep for the right info
> in the .config for you, heres what grepping for COFIG_DEBUG
> looks like:
> CONFIG_DEBUG_FS=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_STACKOVERFLOW=y

oh, this reminds me of a similar report we had for ath5k:

https://bugzilla.kernel.org/show_bug.cgi?id=15861

the subject on this mailing list was "ath5k misbehaving affecting other kernel 
parts unrelated?"

bruno
