Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1KCAGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:06:22 -0400
Received: from ozlabs.org ([203.10.76.45]:44807 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1KCAGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:06:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tim Bird <tim.bird@am.sony.com>, Jason Wessel <jason.wessel@windriver.com>
Cc: David Decotigny <david.decotigny@google.com>,
        Kroah-Hartman <gregkh@suse.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Richard\@mail2.fw-bc.sony.com" <Richard@mail2.fw-bc.sony.com>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "kgdb-bugreport\@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Dmitry Torokhov <dtor@vmware.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        "David\@mail2.fw-bc.sony.com" <David@mail2.fw-bc.sony.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Greg\@mail2.fw-bc.sony.com" <Greg@mail2.fw-bc.sony.com>,
        Satoru Moriya <satoru.moriya@hds.com>, Sievers <kay.sievers@vrfy.org>,
        Decotigny <decot@google.com>,
        "Kay\@mail2.fw-bc.sony.com" <Kay@mail2.fw-bc.sony.com>,
        Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [Kgdb-bugreport] [PATCH v2 3/3] param: make /sys/module/*/paramaters optional
In-Reply-To: <4EB16EC3.8020209@am.sony.com>
References: <cover.1320191327.git.david.decotigny@google.com> <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com> <4EB145FB.70906@windriver.com> <4EB16EC3.8020209@am.sony.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 03 Nov 2011 08:21:30 +1030
Message-ID: <87mxcetcpp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011 09:24:35 -0700, Tim Bird <tim.bird@am.sony.com> wrote:
> On 11/2/2011 6:30 AM, Jason Wessel wrote:
> > On 11/01/2011 06:50 PM, David Decotigny wrote:
> I would also like to see the size numbers.  However, to address
> Jason's concern, I think it's safe to assume that when someone is
> getting this aggressive with system size, they'll start leaving debug
> features on the floor (printk, kdb, etc.).  What would be appropriate,
> IMHO, would be to add a config dependency for kgdb/kdb and
> NOT resurrect /proc items.  There's work in progress in linux-tiny
> to tackle /proc configurability, and adding back /proc interfaces
> is likely to just have the issue resurface there.
>   -- Tim

This is already CONFIG_EXPERT; I don't think anyone really wants to turn
this off.

Yes, I think the patch comes from a false premise: that the reason that
people don't expost module params in sysfs is due to memory usage, and
that providing a way to turn that off will alleviate their fears.

So, my advice to David: just change the perms on any and all module
parameters you want.  *Then* if someone complains about bloat, you can
re-submit these patches and cc: me.

(BTW, don't like the first patch: static is nice, but keeping related
code together is nicer).

Cheers,
Rusty.
