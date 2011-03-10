Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1CJKkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:40:31 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:37003 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1CJKk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:40:29 -0500
Message-ID: <4D78AA72.3060202@secunet.com>
Date: Thu, 10 Mar 2011 11:39:46 +0100
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: =?ISO-8859-1?Q?Andreas_Bie=DFmann?= <biessmann@corscience.de>,
        "Hilbrich, Torsten" <Torsten.Hilbrich@secunet.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in, __mark_inode_dirty
References: <fa.8ND6HoGS9dKYUuniFCAoNq+1TFY@ifi.uio.no>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2011 10:40:27.0472 (UTC) FILETIME=[91DAA500:01CBDF0F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into the same problem and successfully applied your fix.

I was able to reproduce this panic and bisected it to the following commit:

commit aaead25b954879e1a708ff2f3602f494c18d20b5
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Oct 4 14:25:33 2010 +0200

    writeback: always use sb->s_bdi for writeback purposes

The steps to reproduce it on my test system (T60p with Intel Core Duo) were.

- /dev/sdb is an USB stick with partition sdb1 formatted as ext2
- mount /dev/sdb1 /mnt
- cat > /mnt/foo
- now press return some times
- remove stick
- press return, panic takes place

Hope this helps fixing the problem,

	Torsten
