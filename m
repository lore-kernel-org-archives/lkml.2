Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab2AUEBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 23:01:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46866 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab2AUEBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 23:01:17 -0500
Date: Fri, 20 Jan 2012 20:00:58 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Lennart Poettering <mzxreary@0pointer.de>
cc: Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
In-Reply-To: <20120121030204.GE2100@tango.0pointer.de>
Message-ID: <alpine.LSU.2.00.1201201951100.1448@eggly.anvils>
References: <4F13DA90.2000603@cn.fujitsu.com> <4F13DAA9.4070703@cn.fujitsu.com> <20120117175322.GC6762@google.com> <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com> <20120118213638.GA21533@google.com> <20120119014727.GG29242@tango.0pointer.de>
 <20120119022005.GG21533@google.com> <20120119024021.GI21533@google.com> <20120121030204.GE2100@tango.0pointer.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jan 2012, Lennart Poettering wrote:
> On Wed, 18.01.12 18:40, Tejun Heo (tj@kernel.org) wrote:
> > On Wed, Jan 18, 2012 at 06:20:05PM -0800, Tejun Heo wrote:
> > 
> > Also note that tmpfs also implies size limit.  We definitely need some
> > form of control over the amount of memory xattr may consume.
> 
> Good point. But then again we don't even have anything resembling for
> tmpfs either, where it would be much more important... :-(

But although the tmpfs framework for xattrs is general, the validation
function only permits XATTR_SECURITY_PREFIX and XATTR_TRUSTED_PREFIX.

Yes, it would be very necessary to impose size limits if tmpfs went
beyond those to permit XATTR_USER_PREFIX - which the cgroupfs patch
under discussion does permit.

> 
> Given that cgroupfs is probably mostly read-only for normal users, the
> requirement for quotas on it is probably much less important than for tmpfs
> though.

Hugh
