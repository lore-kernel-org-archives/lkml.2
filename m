Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0H3AtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:49:13 -0400
Received: from v002983.home.net.pl ([212.85.107.189]:58648 "HELO
	v002983.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753828Ab0H3AtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:49:11 -0400
From: Hubert Kario <hka@qbs.com.pl>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [RFC v2 PATCH 0/6] Btrfs: Add hot data relocation functionality
Date: Mon, 30 Aug 2010 02:42:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-ARCH; KDE/4.4.5; i686; ; )
Cc: "bchociej@gmail.com" <bchociej@gmail.com>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmm@us.ibm.com" <cmm@us.ibm.com>,
        "bcchocie@us.ibm.com" <bcchocie@us.ibm.com>,
        "mrlupfer@us.ibm.com" <mrlupfer@us.ibm.com>,
        "crscott@us.ibm.com" <crscott@us.ibm.com>,
        "mlupfer@gmail.com" <mlupfer@gmail.com>,
        "conscott@vt.edu" <conscott@vt.edu>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com> <20100826021343.GA452@sli10-conroe.sh.intel.com>
In-Reply-To: <20100826021343.GA452@sli10-conroe.sh.intel.com>
Organization: QBS Jan =?utf-8?q?Kuba=C5=84?=
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008300242.27331.hka@qbs.com.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 of August 2010 04:13:43 Shaohua Li wrote:
> On Fri, Aug 13, 2010 at 06:22:00AM +0800, bchociej@gmail.com wrote:
> > - Hooks in existing Btrfs functions to track data access frequency
> > 
> >   (btrfs_direct_IO, btrfs_readpages, and extent_write_cache_pages)
> > 
> > - New rbtrees for tracking access frequency of inodes and sub-file
> > 
> >   ranges (hotdata_map.c)
> > 
> > - A hash list for indexing data by its temperature (hotdata_hash.c)
> > 
> > - A debugfs interface for dumping data from the rbtrees (debugfs.c)
> > 
> > - A background kthread for relocating data to faster media based on
> > 
> >   temperature
> 
> Hi,
> I'm wondering if the temperature info can be exported to userspace, and
> let a daemon to do the relocation (by ioctl). A userspace daemon is more
> flexible.

Flexibility of userspace daemon is one thing, the ability to let the admin 
precisely control on which drive data is placed could be really beneficial in 
some scenarios is another thing.

This would also allow online defragmentation, together with access to 
statistics, one that (for quick runs) has really good time/performance benefit 
ratio.
-- 
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawerów 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
