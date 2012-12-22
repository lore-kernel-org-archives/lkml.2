Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2LVVr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 16:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2LVVry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 16:47:54 -0500
Date: Sat, 22 Dec 2012 19:45:52 -0200
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Dietmar Maurer <dietmar@proxmox.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>, "aquini@redhat.com" <aquini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        John Stultz <john.stultz@linaro.org>, Mel Gorman <mgorman@suse.de>,
        "agl@us.ibm.com" <agl@us.ibm.com>,
        "amit.shah@redhat.com" <amit.shah@redhat.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Qemu-devel] [RFC 3/3] virtio-balloon: add auto-ballooning
 support
Message-ID: <20121222194552.55c9a97d@doriath>
In-Reply-To: <24E144B8C0207547AD09C467A8259F75578B8BD8@lisa.maurer-it.com>
References: <1355861815-2607-1-git-send-email-lcapitulino@redhat.com>
	<1355861815-2607-4-git-send-email-lcapitulino@redhat.com>
	<20121218225330.GA28297@lizard.mcd00620.sjc.wayport.net>
	<20121219093039.51831f6f@doriath.home>
	<24E144B8C0207547AD09C467A8259F75578B8BD8@lisa.maurer-it.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 05:24:12 +0000
Dietmar Maurer <dietmar@proxmox.com> wrote:

> > > Wow, you're fast! And I'm glad that it works for you, so we have two
> > > full-featured mempressure cgroup users already.
> > 
> > Thanks, although I think we need more testing to be sure this does what we
> > want. I mean, the basic mechanics does work, but my testing has been very
> > light so far.
> 
> Is it possible to assign different weights for different VMs, something like the vmware 'shares' setting?

This series doesn't have the "weight" concept, it has auto-balloon-level and
auto-balloon-granularity. The former allows you to choose which type of
kernel low-mem level you want auto-inflate to trigger. The latter allows you
to say by how much the balloon should grow (as a percentage of the guest's
current memory).

Both of them are per VM.
