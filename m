Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1IES1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:27:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52798 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1IES1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:27:34 -0400
Date: Mon, 5 Sep 2011 20:27:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 08/16] ext4: Calculate and verify checksums for inode bitmaps
Message-ID: <20110905182727.GH7761@one.firstfloor.org>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003127.31048.13983.stgit@elm3c44.beaverton.ibm.com> <2A834E5A-F07E-4B1E-835B-FBEE3FD7A103@dilger.ca> <20110902191828.GL12086@tux1.beaverton.ibm.com> <8D646179-FD76-4362-A051-8C6ADB3CE1B3@dilger.ca> <20110905182250.GO12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905182250.GO12086@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One very interesting optimization would be to profile the metadata workload
where you got the slowdown and try to figure out which fields
were most commonly updated.

If it's some superblock fields or similar maybe those could get their separate
crcs that could be separatedly computed at much lower cost.

-Andi
