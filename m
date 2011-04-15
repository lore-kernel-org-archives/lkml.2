Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1DOWz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:55:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51288 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1DOWzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:55:55 -0400
MIME-Version: 1.0
Message-ID: <5d23c6c4-5d68-4c2e-af24-2a08f592cb8e@default>
Date: Fri, 15 Apr 2011 15:53:47 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
        mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, hch@infradead.org,
        ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com,
        avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org
Subject: RE: [PATCH] xen: cleancache shim to Xen Transcendent Memory
References: <20110414212002.GA27846@ca-server1.us.oracle.com
 1302904935.22658.9.camel@localhost.localdomain>
In-Reply-To: <1302904935.22658.9.camel@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DA8CC8A.006E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ian Campbell [mailto:Ian.Campbell@citrix.com]
> Sent: Friday, April 15, 2011 4:02 PM
> Subject: Re: [PATCH] xen: cleancache shim to Xen Transcendent Memory
> 
> On Thu, 2011-04-14 at 14:20 -0700, Dan Magenheimer wrote:
> > [PATCH] xen: cleancache shim to Xen Transcendent Memory
> >
> > This patch provides a shim between the kernel-internal cleancache
> > API (see Documentation/mm/cleancache.txt) and the Xen Transcendent
> > Memory ABI (see http://oss.oracle.com/projects/tmem).
> 
> There's no need to build this into a kernel which doesn't have
> cleancache (or one of the other frontends), is there? I think there
> should be a Kconfig option (even if its not a user visible one) with
> the appropriate depends/selects.

Yes, you're right.  It should eventually depend on

CONFIG_CLEANCACHE || CONFIG_FRONTSWAP

though there's no sense merging this xen cleancache
shim at all unless/until Linus merges cleancache
(and hopefully later some evolution of frontswap).

And once cleancache (and/or frontswap) is merged,
there's very little reason NOT to enable one or
both on a Xen guest kernel.

Thanks,
Dan
