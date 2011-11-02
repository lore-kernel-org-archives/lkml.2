Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1KBNcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:32:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:61750 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1KBNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:32:09 -0400
Message-ID: <4EB145FB.70906@windriver.com>
Date: Wed, 2 Nov 2011 08:30:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Decotigny <david.decotigny@google.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, Rusty Russell <rusty@rustcorp.com.au>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kgdb-bugreport@lists.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Schmidt <mschmidt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dmitry Torokhov <dtor@vmware.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Satoru Moriya <satoru.moriya@hds.com>,
        David Decotigny <decot@google.com>
Subject: Re: [PATCH v2 3/3] param: make /sys/module/*/paramaters optional
References: <cover.1320191327.git.david.decotigny@google.com> <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com>
In-Reply-To: <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 06:50 PM, David Decotigny wrote:
> From: David Decotigny <decot@google.com>
>
> With this patch, we allow systems that don't want to pay the price for
> /sys/module/*/paramaters to be compiled without that feature. This
> abiltity can in turn encourage module developers to expose more of
> their parameters with fewer hesitations (eg. memory concerns, etc.);
> this is desirable to help debugging/auditing of live (larger) systems.
>
> The new knob to control that is CONFIG_SYSFS_MODULE_PARAM available in
> Kconfig in expert mode: File systems / Pseudo filesystems / sysfs file
> system support / Module parameters in sysfs. It is enabled by default,
> keeping /sys/module/*/paramaters/ available as before.
>
> As an illustration, on my copy I see 1658 module_param() macros with
> perm == 0: most of these could be exposed to user (perm != 0).

Speaking as an embedded developer who works on very small systems that you can still debug, I am really curious what you actually save here?

For dynamic kgdb/kdb this patch is a death sentence.  It would make us have to resurrect the procfs entries for the control point.  There is no possible way to dynamically turn kgdb on and off at all if you remove the /sys/module/kgdboc/parameters/kgdboc entry, and this is certainly something where the typical use case is dynamic enablement.

Jason.
