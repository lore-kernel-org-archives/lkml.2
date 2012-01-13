Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab2AMUiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:38:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60739 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <4F10929E.8070007@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 12:37:53 -0800
X-Google-Sender-Auth: 1-ur7WYpWH3MSKaNcHjHSVTRVyw
Message-ID: <CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com>
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
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:22 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> However, it is to be noted that, technically this warning (machinecheck1
> not having a release() function) is not all that new. Just that people
> didn't probably notice it earlier (reason explained below).

.. but there really is some semantic issue going on here. I'm not the
only one for whom suspend/resume simply does not work with MCE
enabled, and that "not work" coincides with the switch-over from
sysdev to struct device.

I suspect it is some subtle difference in sysdev_unregister() vs
device_unregister(). The message change is just a symptom of the fact
that we go through different paths.

For me MCE hangs only on the *second* suspend, but it sounds like
others see it on the first one.

                        Linus
