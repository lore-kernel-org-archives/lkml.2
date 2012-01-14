Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2ANDKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 22:10:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60358 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2ANDKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 22:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <4F10F117.40006@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com> <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
 <4F10F117.40006@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 19:10:27 -0800
X-Google-Sender-Auth: aJN0PJhsads6BdROAugwnTokUv4
Message-ID: <CA+55aFwWU8ieuV_EsA6nHwjV9iOgy04DEScngDKQ92wNGfPZ-Q@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
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

On Fri, Jan 13, 2012 at 7:05 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On Fri, Jan 13, 2012 at 6:41 PM, Srivatsa S. Bhat
>> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>>> The patch below works perfectly for me - I tested multiple CPU hotplug
>>> operations as well as multiple pm_test runs at core level. Please let me
>>> know if this solves the suspend issue as well..
>>
>> Ok, I'll try, and I bet it does.

Yup, I can suspend and resume multiple times now.

> I totally agree with you. Even I had set out to find out *exactly* what
> was going wrong. After spending significant amount of time digging through
> the code (unsuccessfully), this idea of zeroing out everything struck me
> and it worked, as expected. Yes, it is definitely important to know the
> exact issue so that we can fix the driver core and avoid other mishaps,
> but I guess finding that out is not all that simple.. as of now I am
> rather exhausted following those zillions of pointers continuously
> for the past few hours.. ;-/

Fair enough. The many layers of clever indirection are really really
nasty to follow, I agree.

                   Linus
