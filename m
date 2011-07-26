Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1GZScg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1GZSca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:32:30 -0400
Date: Tue, 26 Jul 2011 13:41:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, lizf@cn.fujitsu.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Subject: Re: [PATCH v3] blk-cgroup:be able to remove the record of unplugged
 device
Message-ID: <20110726174148.GC13780@redhat.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <20110726144427.GB13780@redhat.com>
 <CAJniumVm=oH_yJAgaTzwVu1XwJfn8eAsHw2Cm0tfvg=unA6hkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJniumVm=oH_yJAgaTzwVu1XwJfn8eAsHw2Cm0tfvg=unA6hkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 10:17:16AM -0700, Paul Menage wrote:
> On Tue, Jul 26, 2011 at 7:44 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>       char *s[4], *p, *major_s = NULL, *minor_s = NULL;
> >>       int ret;
> >> -     unsigned long major, minor, temp;
> >> +     unsigned long major, minor, weight;
> >
> > Do not replace temp with name weight. The place you are parsing it,
> > it could be weight, bps or iops. So lets keep the generic name in
> > place.
> 
> The variable currently called "temp" is only ever stored in
> newpn->val.weight. iops and bps already have their own local
> variables.

They have but the context where temp is being used to figure out if it
is a deletion rule is generic. So if a rule is being deleted (be it
weight, bps or iops), we are going to parse it early in the function.
So in that context not calling it "weight" makes sense to me.

We use bps, iops names only after knowing the value type.

Thanks
Vivek
