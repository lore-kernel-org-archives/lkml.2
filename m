Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905Ab2ANFPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:15:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49963 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2ANFPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:15:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwWU8ieuV_EsA6nHwjV9iOgy04DEScngDKQ92wNGfPZ-Q@mail.gmail.com>
References: <20120111000051.GA28874@dztty>
	<CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
	<4F10929E.8070007@linux.vnet.ibm.com>
	<CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
	<4F10BDF7.8030306@linux.vnet.ibm.com>
	<CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
	<4F10EB5B.5060804@linux.vnet.ibm.com>
	<CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
	<4F10F117.40006@linux.vnet.ibm.com>
	<CA+55aFwWU8ieuV_EsA6nHwjV9iOgy04DEScngDKQ92wNGfPZ-Q@mail.gmail.com>
Date: Fri, 13 Jan 2012 21:15:29 -0800
X-Google-Sender-Auth: 5T8E0Z7OxH3lwquaHM7molHVXZw
Message-ID: <CA+8MBbJ7wvzPtW8g0qd4R74tYs-tujCRCvjhue3gah_prtsLLg@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 7:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Fair enough. The many layers of clever indirection are really really
> nasty to follow, I agree.

You could cheat and bisect (not git bisect, numerical bisect). We know that:

      memset(&dev->kobj, 0, sizeof(struct kobject));

is not enough. And that:

      memset(dev, 0, sizeof(struct device));

works. The kobject is near the beginning of struct device. So try clearing
all the other bits from start of struct device up to "kobj" ... if that doesn't
help, then play with clearing various sized chunks after. Should be able to
zoom in on the culprit field ... then go look at the code.

-Tony
