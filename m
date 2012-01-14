Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2ANApm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 19:45:42 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:56522
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988Ab2ANApk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 19:45:40 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0E0j1Dp008601
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx\@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
In-Reply-To: <CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 13 Jan 2012 12:37:53 -0800")
References: <20120111000051.GA28874@dztty>
	<CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
	<4F10929E.8070007@linux.vnet.ibm.com>
	<CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Sat, 14 Jan 2012 01:44:59 +0100
Message-ID: <gir4z3cdtg.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Sat, 14 Jan 2012 01:45:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Jan 13, 2012 at 12:22 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> However, it is to be noted that, technically this warning (machinecheck1
>> not having a release() function) is not all that new. Just that people
>> didn't probably notice it earlier (reason explained below).
>
> .. but there really is some semantic issue going on here. I'm not the
> only one for whom suspend/resume simply does not work with MCE
> enabled, and that "not work" coincides with the switch-over from
> sysdev to struct device.
>
> I suspect it is some subtle difference in sysdev_unregister() vs
> device_unregister(). The message change is just a symptom of the fact
> that we go through different paths.
>
> For me MCE hangs only on the *second* suspend, but it sounds like
> others see it on the first one.

Yes, my laptop hangs on the first suspend.
Another effect of the problem is that the laptop's clock is extremely
off after a forced reboot.

Dirk
