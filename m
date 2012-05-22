Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2EVKMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab2EVKMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:12:19 -0400
Date: Tue, 22 May 2012 12:12:09 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120522101208.GB8382@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <CAE9FiQXUM-+KSZ1OcxipRW-3XQED3Csyxs=0ke0hJZR7E_hrhg@mail.gmail.com>
 <20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
 <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:44:39PM -0700, Suresh Siddha wrote:
> On Mon, 2012-05-21 at 10:13 +0200, Alexander Gordeev wrote:
> > So we really need to submit all possible CPUs here ^^^ to be able finding the
> > best/heaviest cluster out of the 'mask'.
> > 
> 
> I don't think we need to do anything fancy, like selecting the heaviest
> cluster out of the mask. Something like (cluster membership of first cpu
> in the mask) AND (mask) should be enough.

Hmm... the cost of selecting a cluster is cheap. It is called from a setup code
that should not be fast. Why not keep it?.. Well in case the data would show it
worth it.

What seems worthy though is sticking to the cluster which is currently in use
and at least one of its CPUs is still in the mask.

> thanks,
> suresh

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
