Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1DTN6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:58:16 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:44787 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753449Ab1DTN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:58:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ZtHoZv0VM1np0DLECk830bq61GITWjc1fiuVICLmpEHcFxJ
 e42rmi0PrDnOzOwo1ME_YAgJ5JJBQdNDkvWvXjH3p9Or7G3cjYwbboRpKhL2
 7uP_j2mEl2LhMw4LbxIwR7PBmhtERh9vIYWFA_hbS0A9aRk1BUI8VfDpqRva
 6cH5GuoyKe6pVRX2L0HgHz6vQA4wgva5E0_B4ch0S9VwgVhd5t5WpTWAVwRi
 z6YEPi2ecycUS.3ffDCDe_5E6eh5DA9qIjegj5eMolftnpITSDe_MNz8Z0MD
 uY0i12AVx1GPq2lc6dY2h_fre0.3IfxiVx2WZ9ghw4CvPFj6M
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 20 Apr 2011 08:58:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Matthew Wilcox <matthew@wil.cx>
cc: Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <20110420112020.GA31296@parisc-linux.org>
Message-ID: <alpine.DEB.2.00.1104200855050.8634@router.home>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com> <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com> <20110420112020.GA31296@parisc-linux.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Matthew Wilcox wrote:

> On Wed, Apr 20, 2011 at 10:34:23AM +0300, Pekka Enberg wrote:
> > That part makes me think the best option is to make parisc do
> > CONFIG_NUMA as well regardless of the historical intent was.
>
> But it's not just parisc.  It's six other architectures as well, some
> of which aren't even SMP.  Does !SMP && NUMA make any kind of sense?

Of course not.

> I think really, this is just a giant horrible misunderstanding on the part
> of the MM people.  There's no reason why an ARM chip with 16MB of memory
> at 0 and 16MB of memory at 1GB should be saddled with all the NUMA gunk.

DISCONTIG has fallen out of favor in the last years. SPARSEMEM has largely
replaced it. ARM uses that and does not suffer from these issue.

No one considered the issues of having a !NUMA configuration with
nodes (which DISCONTIG seems to create) when developing core code in the
last years. The implicit assumption has always been that page_to_nid(x)
etc is always zero on a !NUMA configuration.
