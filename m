Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1HESuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:50:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378Ab1HESue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110803164837.GA2669@elie>
References: <20110210144057.GA7193@mail.hallyn.com> <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
 <20110803164837.GA2669@elie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Aug 2011 08:50:06 -1000
Message-ID: <CA+55aFw0d0bGQhtLB602=_i-PAMmkBs0vRocvtRZUU33xS8=4A@mail.gmail.com>
Subject: Re: [PATCH/RFC] cap_syslog: make CAP_SYS_ADMIN deprecation notice
 less alarming
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Gergely Nagy <algernon@balabit.hu>,
        david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
        Nick Bowler <nbowler@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 6:48 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
>
> Convert the WARN_ONCE to a printk_once to avoid this while continuing
> to give userspace developers a hint that this is an unwanted
> backward-compatibility feature and won't be around forever.

The problem with this one is that converting away from a warning
doesn't just get rid of all the ugliness, it gets rid of some of the
*useful* information in the warning too.

In particular, when you have a warning like "Attempting to access
syslog", you'd better tell people *who* is attempting to access
syslog, so that they can fix it or complain to the right person.

And the warning does show what process it is (in addition to
stacktrace, tainting etc that we don't want). Your printk_once()
conversion does not.

         Linus
