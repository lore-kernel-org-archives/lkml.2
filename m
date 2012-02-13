Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2BMV5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:57:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46517 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab2BMV5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:57:46 -0500
MIME-Version: 1.0
In-Reply-To: <4F39763D.3070609@linux.vnet.ibm.com>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
	<20120201140125.c656df41.akpm@linux-foundation.org>
	<87d39xj955.fsf@rustcorp.com.au>
	<CA+8MBbJcTgj7X-7RZAgWk8a3Qyaz1FxFzu3ZLk-8LHKD7M8h-Q@mail.gmail.com>
	<4F3971A1.5010305@linux.vnet.ibm.com>
	<4F39763D.3070609@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2012 13:57:45 -0800
Message-ID: <CA+8MBbLR+rcJqe2z9tAt7Oav4wqgZA3k8Te6zcXNOs+zv2wAaA@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
From: Tony Luck <tony.luck@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 12:44 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> IOW, what output do you see from the following printk from
> arch/ia64/kernel/smpboot.c?
>
> printk(KERN_INFO "Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
>         (int)num_online_cpus(), bogosum/(500000/HZ), (bogosum/(5000/HZ))%100);

That is a complicated question - because linux-next also has patches
by Arjan that
change how (when) cpus are brought online. Initially I blamed his
patches and tried
reverting them ... and saw the symptom you are wondering about (message said
"Total of 1 processors", but the BogoMIPs was a number big enough to be all of
them. Thanks to you, I can now understand why.

Fix will be to stop ia64 from messing directly with cpu_online_map?

-Tony
