Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2DDPgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:36:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51990 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab2DDPgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:36:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120404145134.GC12676@redhat.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120404145134.GC12676@redhat.com>
Date: Wed, 4 Apr 2012 10:36:04 -0500
Message-ID: <CAH2r5mtwQa0Uu=_Yd2JywVJXA=OMGV43X_OUfziC-yeVy9BGtQ@mail.gmail.com>
Subject: Re: [Lsf] [RFC] writeback and cgroup
From: Steve French <smfrench@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 9:51 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 03, 2012 at 11:36:55AM -0700, Tejun Heo wrote:
>
> Hi Tejun,
>
> Thanks for the RFC and looking into this issue. Few thoughts inline.
>
> [..]
>> IIUC, without cgroup, the current writeback code works more or less
>> like this.  Throwing in cgroup doesn't really change the fundamental
>> design.  Instead of a single pipe going down, we just have multiple
>> pipes to the same device, each of which should be treated separately.
>> Of course, a spinning disk can't be divided that easily and their
>> performance characteristics will be inter-dependent, but the place to
>> solve that problem is where the problem is, the block layer.
>
> How do you take care of thorottling IO to NFS case in this model? Current
> throttling logic is tied to block device and in case of NFS, there is no
> block device.

Similarly smb2 gets congestion info (number of "credits") returned from
the server on every response - but not sure why congestion
control is tied to the block device when this would create
problems for network file systems

-- 
Thanks,

Steve
