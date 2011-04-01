Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1DAIqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 04:46:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47845 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1DAIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 04:46:16 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: victor.vde@gmail.com, util-linux@vger.kernel.org, miklos@szeredi.hu,
        linuxram@us.ibm.com, viro@zeniv.linux.org.uk, victor.vde@gmail.com,
        ejmarkow@yahoo.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <87d3l62z3k.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [BUG] libmount misparses mountinfo on Linux v2.6.39-rc1
References: <19860.58082.277944.875401@gargle.gargle.HOWL> <87d3l62z3k.fsf@linux.vnet.ibm.com>
Message-Id: <E1Q5ZzI-0001M4-0j@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 01 Apr 2011 10:45:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Apr 2011, Aneesh Kumar K. V wrote:
> On Thu, 31 Mar 2011 22:24:01 +0200, victor.vde@gmail.com wrote:
> > /proc/self/mountinfo on Linux v2.6.39-rc1 includes the UUID of ext4
> > and ext3 mounts, for example:
> > 
> > 15 1 8:3 / / rw,noatime uuid:c645234d-9756-4d84-825e-6fe999252a34 - ext4 /dev/sda3 rw,user_xattr,acl,barrier=1,data=ordered
> > 
> > It seems the hyphens in the uuid confuse the parser
> > mnt_parse_mountinfo_line in tab_parse.c of libmount in util-linux.
> 
> shouldn't the parser look for " " followed by "-" followed by " " as the
> field seperator ? 
> 
> I am adding Miklos and Ram Pai to CC to check whether the kernel or the libmount 
> should be fixed ?

I think libmount should be fixed, though there is always the question
of backward compatibility.

However I don't see how the kernel could be fixed, given that libmount
doesn't seem to parse escape sequences (e.g. "\040" for space), which
it also should.

Karel?

Thanks,
Miklos
