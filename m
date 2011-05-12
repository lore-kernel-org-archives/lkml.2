Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab1ELOi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:38:27 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:48910 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757774Ab1ELOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:38:26 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jqg75swVM1kIt847AkeO656TgKuZADAqFYCwpLenYd55rgp
 OUoUYrO8ldAiMjzY.7siLoz90kv5OxJGHluQy2HY6I9GIpskTNA_tFyO8B_S
 N2oa7.mglQR7B0VvUuM9SLOo8xuXhvAtLh3Gc218X33fh3S.WDvp7V9Lo_QW
 erKym0cgbrgOwvr2q4cwR2Q1he_OccCZIueLb6xe4qVQjhrO1eKMP68o4G7q
 MiuX3yCxHkJ5Esr_YyfOLTACO6G14K7DtwwMClAXAsDyqsvW.O3NjBMX9B9.
 4g7739tXzsRXq50xMXEeDkSlEQJeO6rX5u1lshWj_7jqTyAxU
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 09:38:22 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, eric.dumazet@gmail.com, npiggin@kernel.dk
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
In-Reply-To: <20110511092848.GE1661@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1105120938160.24560@router.home>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com> <20110511092848.GE1661@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011, Tejun Heo wrote:

> Hey, Shaohua.
>
> On Wed, May 11, 2011 at 04:10:12PM +0800, Shaohua Li wrote:
> > The new implementation uses lglock to protect percpu data. Each cpu has its
> > private lock while other cpu doesn't take. In this way _add doesn't need take
> > global lock anymore and remove the deviation. This still gives me about
> > about 5x ~ 6x faster (not that faster than the original 7x faster, but still
> > good) with the workload mentioned in patch 4.
>
> I'm afraid I'm not too thrilled about lglock + atomic64 usage.  It is
> a very patchy approach which addresses a very specific use case which
> might just need a higher @batch.  I just can't see enough benefits to
> justify the overhead and complexity.  :-(

Same here.

