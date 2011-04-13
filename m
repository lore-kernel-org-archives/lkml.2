Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab1DMW5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:57:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33343 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606Ab1DMW5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=DecnQOq9QPEJcSwt4khobC6uQbFE4oym561Ww+QzDx26IJlHiQm6bCjVWO4mBKWuuE
         y2su9NKQGL90a508bjBSkYCk7+Ih7e0Rik57g6kI4zmhIlsSFk5f/DDrT6p8tP3gT5DJ
         v5BpWlFmSBWiSb+aXuebo/fOFlrHA+FhE59xs=
MIME-Version: 1.0
In-Reply-To: <201104140049.23344.rjw@sisk.pl>
References: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com>
 <201104132353.09282.rjw@sisk.pl> <BANLkTik1tg2fzFgZmeSCGZxbNPDydotb-w@mail.gmail.com>
 <201104140049.23344.rjw@sisk.pl>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 13 Apr 2011 18:57:13 -0400
X-Google-Sender-Auth: bd4BP5_DhanvddW_KhevMDRCapQ
Message-ID: <BANLkTi=_+kYvs3_dsXifd_rkxfmFzJLttA@mail.gmail.com>
Subject: Re: freezer: should barriers be smp ?
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 18:49, Rafael J. Wysocki wrote:
> On Thursday, April 14, 2011, Mike Frysinger wrote:
>> i guess the trouble for us is that you have one CPU posting writes to
>> task->flags (and doing so by grabbing the task's spinlock), but the
>> other CPU is simply reading those flags.  there are no SMP barriers in
>> between the read and write steps, nor is the reading CPU grabbing any
>> locks which would be an implicit SMP barrier.  since the Blackfin SMP
>> port lacks hardware cache coherency, there is no way for us to know
>> "we've got to sync the caches before we can do this read".  by using
>> the patch i posted above, we have that signal and so things work
>> correctly.,
>
> In theory I wouldn't expect the patch to work correctly, because it replaces
> _stronger_ memory barriers with _weaker_ SMP barriers.  However, looking at
> the blackfin's definitions of SMP barriers I see that it uses extra stuff that
> should _also_ be used in the definitions of the mandatory barriers.
>
> In my opinion is an architecture problem, not the freezer code problem.

OK, we have a patch pending locally which populates all barriers with
this logic, but based on my understanding of things, that didnt seem
correct.  i guess i'm reading too much into the names ... i'd expect
the opposite behavior where "rmb" is only for UP needs while "smp_rmb"
is a rmb which additionally covers SMP.
-mike
