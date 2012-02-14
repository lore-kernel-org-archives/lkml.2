Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197Ab2BNVAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:00:01 -0500
Received: from ozlabs.org ([203.10.76.45]:39233 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761036Ab2BNVAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:00:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tony Luck <tony.luck@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
In-Reply-To: <CA+8MBbLR+rcJqe2z9tAt7Oav4wqgZA3k8Te6zcXNOs+zv2wAaA@mail.gmail.com>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com> <1328055439-9441-1-git-send-email-venki@google.com> <20120201140125.c656df41.akpm@linux-foundation.org> <87d39xj955.fsf@rustcorp.com.au> <CA+8MBbJcTgj7X-7RZAgWk8a3Qyaz1FxFzu3ZLk-8LHKD7M8h-Q@mail.gmail.com> <4F3971A1.5010305@linux.vnet.ibm.com> <4F39763D.3070609@linux.vnet.ibm.com> <CA+8MBbLR+rcJqe2z9tAt7Oav4wqgZA3k8Te6zcXNOs+zv2wAaA@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Feb 2012 19:55:36 +1030
Message-ID: <87wr7pbwbz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 13:57:45 -0800, Tony Luck <tony.luck@gmail.com> wrote:
> On Mon, Feb 13, 2012 at 12:44 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > IOW, what output do you see from the following printk from
> > arch/ia64/kernel/smpboot.c?
> >
> > printk(KERN_INFO "Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
> >         (int)num_online_cpus(), bogosum/(500000/HZ), (bogosum/(5000/HZ))%100);
> 
> That is a complicated question - because linux-next also has patches
> by Arjan that
> change how (when) cpus are brought online. Initially I blamed his
> patches and tried
> reverting them ... and saw the symptom you are wondering about (message said
> "Total of 1 processors", but the BogoMIPs was a number big enough to be all of
> them. Thanks to you, I can now understand why.
> 
> Fix will be to stop ia64 from messing directly with cpu_online_map?

Yes, and the other architectures.

We're well within reach of removing cpu_*_map now I think.

Cheers,
Rusty.

