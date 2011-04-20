Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1DTLUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:20:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35763 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1DTLUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:20:22 -0400
Date: Wed, 20 Apr 2011 05:20:20 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Pekka Enberg <penberg@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
	expand_upwards
Message-ID: <20110420112020.GA31296@parisc-linux.org>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com> <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:34:23AM +0300, Pekka Enberg wrote:
> That part makes me think the best option is to make parisc do
> CONFIG_NUMA as well regardless of the historical intent was.

But it's not just parisc.  It's six other architectures as well, some
of which aren't even SMP.  Does !SMP && NUMA make any kind of sense?

I think really, this is just a giant horrible misunderstanding on the part
of the MM people.  There's no reason why an ARM chip with 16MB of memory
at 0 and 16MB of memory at 1GB should be saddled with all the NUMA gunk.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
