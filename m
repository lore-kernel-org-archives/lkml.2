Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1AGLMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:12:25 -0500
Received: from shutemov.name ([188.40.19.243]:52207 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab1AGLMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:12:23 -0500
Date: Fri, 7 Jan 2011 13:12:22 +0200
From: "Kirill A. Shutemov" <kas@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Kirill A. Shutemov" <kas@openvz.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, linux-nfs@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] make rpc_pipefs be mountable multiple time
Message-ID: <20110107111222.GA19395@shutemov.name>
References: <1293628470-28386-1-git-send-email-kas@openvz.org>
 <20110105114155.GN19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105114155.GN19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 11:41:55AM +0000, Al Viro wrote:
> On Wed, Dec 29, 2010 at 03:14:18PM +0200, Kirill A. Shutemov wrote:
> > Prepare nfs/sunrpc stack to use multiple instances of rpc_pipefs.
> 
> Won't that make sunrpc impossible to rmmod once you've got it in?
> Note that having a reference to vfsmount pins it down, which pins
> the superblock down, which pins the file_system_type down, which
> pins the damn module down.  So cleanup_sunrpc() won't be ever called,
> AFAICS...

Hm.. rpc_pipe_fs_type.owner = NULL seems fix the problem.
Is it valid solution in this case?

-- 
 Kirill A. Shutemov
