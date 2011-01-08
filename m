Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab1AHHnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 02:43:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33542 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1AHHnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 02:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oBNAGMvxa1+B0MJo8kuXCAhggtOrklUXXtRNZOR4O8XbhQqOVGo3osJD/2qegp7S+e
         k7l8avVPB+nC0KiLLH5ragTTSqW6hyM1aPWDV626ZK2+U4ztYaHVq34r03Wf18+BDbHi
         cfCHUtBd2V5nse7T8BtyXP/DlOsC3KoZ9QRNs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
 <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
 <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>
 <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
 <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101061107500.8655@router.home> <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1101070922100.3014@router.home> <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 8 Jan 2011 08:42:42 +0100
X-Google-Sender-Auth: YVwmsXNDS4hjY-XinijqZuPIt7M
Message-ID: <AANLkTin6N2s1RN6PBX=f0v69Ny-NkEKk_iAgqscuYgMM@mail.gmail.com>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 9:34 PM, David Rientjes <rientjes@google.com> wrote:
>
> On Fri, 7 Jan 2011, Christoph Lameter wrote:
>
> > Subject: slub: Avoid use of slub_lock in show_slab_objects()
> >
> > The purpose of the locking is to prevent removal and additions
> > of nodes when statistics are gathered for a slab cache. So we
> > need to avoid racing with memory hotplug functionality.
> >
> > It is enough to take the memory hotplug locks there instead
> > of the slub_lock.
> >
>
> Because memory hotplug is the only time s->node[] is modified after the
> sysfs files are created, which is the only time show_slab_objects() is
> called.
>
> > online_pages() does not acquire the memory_hotplug lock. So
> > add the missing locking there.
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Acked-by: David Rientjes <rientjes@google.com>
>
>  [ Should probably be seperated out into two patches, one for the
>   memory hotplug locking addition and one for the slub fix, both
>   should be pushed during this merge window.  If so, a comment
>   describing the new semantics of lock_memory_hotplug() to protect
>   data structures that may be modified in hotplug notifier
>   callbacks would be appreciated. ]

Shouldn't stable@kernel.org be CC-ed too ?

Bart.
