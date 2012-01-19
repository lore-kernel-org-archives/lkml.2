Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2ASBtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:49:31 -0500
Received: from tango.0pointer.de ([85.214.72.216]:34224 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2ASBt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:49:29 -0500
Date: Thu, 19 Jan 2012 02:49:28 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Message-ID: <20120119014928.GH29242@tango.0pointer.de>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <4F168266.3060205@cn.fujitsu.com>
 <20120118174732.GG30664@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118174732.GG30664@google.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18.01.12 09:47, Tejun Heo (tj@kernel.org) wrote:

> 
> Hello,
> 
> On Wed, Jan 18, 2012 at 04:27:18PM +0800, Li Zefan wrote:
> > Furthermore, I noticed tmpfs also implemented xattr support, and we
> > should be able to share most of the code, which makes the cost for
> > having this feature smaller.
> 
> Yes, maybe, but tmpfs doesn't have any special semantics attached to
> files.  It's supposed to store opaque data from userland.  Regardless
> of code complexity, I just don't think this is a good idea.  What if
> we later want to attach certain config meaning to or export statistics
> via xattrs?  That would be quite unusual and require strong rationale
> but at least fall in the similar usage as with the rest of the fs.

If you plan to export kernel data to userspace via xattrs, then you
should probably place that in the system.xxx xattr namespace, not in
the user.xxx or trusted.xxx namespaces which are the only ones which can
be manipulated by userspace.

See attr(5) for more information about the four available xattr
namespaces.

In other words: kernel exported xattrs should never collide with xattrs
set by userspace.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
