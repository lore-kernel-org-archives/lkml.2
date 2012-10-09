Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2JIF2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 01:28:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17642 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2JIF16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 01:27:58 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-68-5073b5dcf310
From: Chul Lee <chur.lee@samsung.com>
To: dave@jikos.cz, "'?????????'" <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
 <20121006222104.GA4405@twin.jikos.cz>
In-reply-to: <20121006222104.GA4405@twin.jikos.cz>
Subject: RE: [PATCH 02/16] f2fs: add on-disk layout
Date: Tue, 09 Oct 2012 14:27:56 +0900
Message-id: <007301cda5de$d68251c0$8386f540$%lee@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2kEOkNghVjcTmnS9W/KF263Pkj7wBzIT8Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd07W4sDDE51Gljs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWsuC5f0MNT0TXvCVsD4x7OLkZODgkBE4n/x58wQdhi
	EhfurWfrYuTiEBJYxChxYsJZdpCEkMAfRonz53JAbDYBVYlzuxYCxTk4RAQsJF40eoPUMwuc
	Y5RYfeIEG0R9qsSVvRA1nAJGEpd2FYOEhQWMJfY2HGUEsVmAxhx6MRfM5hWwlTg/7RELhC0o
	8WPyPTCbWUBLYv3O40wQtrzE5jVvmUFGSgioSzz6qwsSFgGafmPlS3aIEhGJfS/eMU5gFJqF
	ZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBwfxMegfjqgaLQ4wC
	HIxKPLwfoooDhFgTy4orcw8xSnAwK4nwXk8ECvGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJ
	EBJITyxJzU5NLUgtgskycXBKNTDO1LwyRWmJUx1H4NqTG7YqXzpi9u638L0DSju0/3q/LODT
	8n0qObHrnXZEF9sCjRtpRibTfSMse3+cvh7Sq2Tva6/vUdKRf0je6YAhm/hLsVVyd/K0brZ3
	pTD//n5v7X6F/YEG+Z73FE7+ebh/3ctLvSfqXiiu9jBfuvlnxMMDXjofa5bMuPpRiaU4I9FQ
	i7moOBEA+uaLIGICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David Sterba,

David Sterba wrote:
> On Fri, Oct 05, 2012 at 08:56:44PM +0900, ????????? wrote:
> > +struct node_footer {
> > +	__le32 nid;		/* node id */
> > +	__le32 ino;		/* inode nunmber */
> > +	__le32 cold:1;		/* cold mark */
> > +	__le32 fsync:1;		/* fsync mark */
> > +	__le32 dentry:1;	/* dentry mark */
> > +	__le32 offset:29;	/* offset in inode's node space */
> 
> A bitfield for a on-disk structure? This will have endianity issues,
> (but I don't know if you intend to support big-endian). It's not enough
> to use cpu_to_le* as in
> 
> fill_node_footer(...) {
> 
> 	rn->footer.offset = cpu_to_le32(ofs);
> 
> }
> 
> because the bitfield inside the structure will be already defined
> reversed. The cpu_to_le macro will only convert value of 'ofs' but will
> place it to different bits than it would on a little-endian arch.
> 
> There are macros to define bitfields in an endian-neutral way (or do it
> by #ifdefs though it also involves duplicating the item names), or you
> can alternatively use two structs fr disk-only and memory-only access,
> the disk one stores __le32 with value combined of all and the in-memory
> gets set up properly and will look like your current version of the
> structure.
> 
> (More about not using bitfields
> http://yarchive.net/comp/linux/bitfields.html)

I appreciate your kind feedback, but we should've avoided using bitfields
for on-disk structure. As you suggested, we'll revise them. The latter
approach would be good.

> 
> 
> david

Chul

