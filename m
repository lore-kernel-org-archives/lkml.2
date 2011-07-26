Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1GZTYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:24:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1GZTYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:24:49 -0400
Date: Tue, 26 Jul 2011 15:24:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, lizf@cn.fujitsu.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Subject: Re: [PATCH v3] blk-cgroup:be able to remove the record of unplugged
 device
Message-ID: <20110726192441.GD13780@redhat.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <20110726144427.GB13780@redhat.com>
 <CAJniumVm=oH_yJAgaTzwVu1XwJfn8eAsHw2Cm0tfvg=unA6hkA@mail.gmail.com>
 <20110726174148.GC13780@redhat.com>
 <CAJniumW-+aQE0jWr0NhvTUuxLDiP27bQaZVmVORpnNHvPqp0kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJniumW-+aQE0jWr0NhvTUuxLDiP27bQaZVmVORpnNHvPqp0kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:40:26AM -0700, Paul Menage wrote:
> On Tue, Jul 26, 2011 at 10:41 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > They have but the context where temp is being used to figure out if it
> > is a deletion rule is generic. So if a rule is being deleted (be it
> > weight, bps or iops), we are going to parse it early in the function.
> > So in that context not calling it "weight" makes sense to me.
> >
> > We use bps, iops names only after knowing the value type.
> 
> Fair enough - but in that case, wouldn't it make sense to make "temp"
> a u64 and just parse it once, rather than reparsing the iops/bps later
> in their switch cases?

Agreed. That makes sense. Make temp u64 and use strict_strtoull() and
once parsed use that value for weight, bps and iops and don't do
parsing again.

Wanlong, could you please take care of above also in your next posting?

Thanks
Vivek
