Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2DQH1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:27:24 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56633 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2DQH1X convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 17 Apr 2012 03:27:23 -0400
Message-Id: <4F8D3778020000780007E63A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 17 Apr 2012 08:27:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Wilk" <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        "Tim(Xen.org)" <tim@xen.org>, "Sheng Yang" <sheng@yasker.org>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as
 unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com>
 <4F8C33E0.2080007@citrix.com>
 <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
 <4F8C619C020000780007E34E@nat28.tlf.novell.com>
 <84023b26-a682-44b5-990e-1635da6949ff@default>
In-Reply-To: <84023b26-a682-44b5-990e-1635da6949ff@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.04.12 at 19:22, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> In upstream (and recent pv-ops) kernels, is there any need for there
> to be a difference between HVM and PV in the clocksource chosen?  The

Yes, because RDTSC interception for PV guests is slow (using #GP
and requiring instruction decode).

> pvclock algorithm was necessary for PV when non-TSC hardware clocks
> were privileged and the only non-privileged hardware clock (TSC)
> was badly broken in hardware and for migration/save/restore.
> With TSC now working and stable, and now that we are making changes
> in the upstream kernel that work for both PV and HVM, is it
> time to drop pvclock (at least as the default for PV)?
> 
> Certainly if an old (non-pv-ops) kernel is broken, something like
> David's patch might be an acceptable workaround.  I'm just arguing
> against perpetuating pvclock-as-the-only-xen-clock upstream.

Afaict, the only uniformly reliable clocksource for PV guests is the
virtual one which pvclock builds upon. Raw TSC is definitely not an
option on NUMA systems (and PV guests aren't aware of the
NUMAness of the underlying system).

Jan

