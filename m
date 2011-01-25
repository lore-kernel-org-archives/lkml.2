Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1AYOc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:32:56 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:4118 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753620Ab1AYOcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:32:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAOttPk1Ld/sX/2dsb2JhbAAMhAbNV5BigSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,374,1291611600"; 
   d="scan'208";a="89156754"
Message-ID: <4D3EDF13.7010007@teksavvy.com>
Date: Tue, 25 Jan 2011 09:32:51 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <20110124175456.GA17855@core.coreip.homeip.net> <4D3E1A08.5060303@teksavvy.com> <20110125005555.GA18338@core.coreip.homeip.net> <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net> <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net> <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com>
In-Reply-To: <4D3EB734.5090100@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-25 06:42 AM, Mauro Carvalho Chehab wrote:
>
> I lost part of the thread, but a quick search via the Internet showed that you're using
> the input tools to work with a Remote Controller, right? Are you using a vanilla
> kernel, or are you using the media_build backports? There are some distros that are
> using those backports also like Fedora 14.

I use kernel.org kernels exclusively.

> The issue is simple, and it is related on how the input.c used to handle EVIOSGKEYCODE.
> Basically, before allowing you to change a key, it used to call EVIOCGKEYCODE to check
> it that key exists. However, when you're creating a new association, the key didn't
> exist, and, to be strict with input rules, EVIOCGKEYCODE should return -EINVAL.

No, if the parameters are a valid key, then -EINVAL is never the correct
thing for a kernel to return.  -EINVAL means "bad parameters",
and that's not an accurate description of a valid yet unmapped key.

> To circumvent that behaviour, old versions were returning 0, and associating unmapped
> scancodes to KEY_RESERVED. We used this workaround for a few kernel versions, while
> we were discussing the improvements so support larger scancodes.

And now we're stuck with it.  If that is how it works,
and userspace depends upon it (it does), then consider
it cast in stone.  Immutable by Linus's Law: don't break userspace.

Create a new ioctl() number for the new behaviour,
but preserve the old behaviour in exact form for
a suitable (multi-year) overlap period.

Cheers
