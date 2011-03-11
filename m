Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1CKT5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:57:55 -0500
Received: from www.tglx.de ([62.245.132.106]:33189 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab1CKT5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:57:53 -0500
Date: Fri, 11 Mar 2011 20:56:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Scott James Remnant <scott@netsplit.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
In-Reply-To: <AANLkTi=_DG8uYLxDnXF=so5daUE=w-pxL67mYaFAGkkL@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103112054540.2787@localhost6.localdomain6>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org> <20110309162513.5058c824.akpm@linux-foundation.org> <AANLkTin7=rK2Sc2D7aMhPnPWU9LJq7KMSvwxv_PHERcK@mail.gmail.com> <20110310002534.f984f8b2.akpm@linux-foundation.org>
 <AANLkTi=_DG8uYLxDnXF=so5daUE=w-pxL67mYaFAGkkL@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-244858380-1299873414=:2787"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-244858380-1299873414=:2787
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 11 Mar 2011, Scott James Remnant wrote:
> On Thu, Mar 10, 2011 at 12:25 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 9 Mar 2011 18:01:09 -0800 Scott James Remnant <scott@netsplit.com> wrote:
> >
> >> > It would be helpful to know if the identified users of this feature
> >> > actually find it useful and adequate. __I guess the most common
> >> > application is the 1,001 desktop clock widgets. __Do you have any
> >> > feedback from any of the owners of those?
> >> >
> >> cron is another obvious one (or init systems attempting to replace
> >> cron). Having to wakeup and check the time every minute can be
> >> non-conducive to power savings, it would be better if we could just
> >> sleep until the next alarm and be woken up if the time changes in
> >> between.
> >>
> >> (That being said, we also need to poll for and/or check for timezone
> >> changes - but those are entirely userspace, so we can deal with that
> >> separately)
> >
> > Sure, there will be lots of applications.
> >
> > But what I'm asking isn't "it is a good feature".  I'm asking "is the
> > feature implemented well".  Ideally someone would get down and modify
> > cron to use the interface in this patch.
> >
> So I've just been thinking today - and I'm actually not sure whether
> this is needed at all for this case.
> 
> A good cron implementation is going to set timers according to
> CLOCK_REALTIME; in the case where the clock changes forwards, those
> timers will fire as part of the clock changing already no? And in the
> case where the clock changes backwards, you don't want to re-run old
> ones anyway.
> 
> Even the hourly/daily cases are actually at a fixed time, so would be
> triggered - and a decent implementation wouldn't trigger a given
> script more than once.

Yeah, I was wondering about today as well. Though when you set back
your clock several days, stuff might be surprised if it's not woken up
for several days :)

Thanks,

	tglx
---1463795968-244858380-1299873414=:2787--
