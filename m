Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1AELmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:42:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48891 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1AELmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:42:03 -0500
Date: Wed, 5 Jan 2011 11:41:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Kirill A. Shutemov" <kas@openvz.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, linux-nfs@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] make rpc_pipefs be mountable multiple time
Message-ID: <20110105114155.GN19804@ZenIV.linux.org.uk>
References: <1293628470-28386-1-git-send-email-kas@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293628470-28386-1-git-send-email-kas@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 03:14:18PM +0200, Kirill A. Shutemov wrote:
> Prepare nfs/sunrpc stack to use multiple instances of rpc_pipefs.

Won't that make sunrpc impossible to rmmod once you've got it in?
Note that having a reference to vfsmount pins it down, which pins
the superblock down, which pins the file_system_type down, which
pins the damn module down.  So cleanup_sunrpc() won't be ever called,
AFAICS...
