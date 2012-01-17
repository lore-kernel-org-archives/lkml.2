Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2AQImP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:42:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50911 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2AQImN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:42:13 -0500
Message-ID: <4F1534FD.30707@cn.fujitsu.com>
Date: Tue, 17 Jan 2012 16:44:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120116135442.GA28487@shiny>
In-Reply-To: <20120116135442.GA28487@shiny>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-17 16:41:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-17 16:41:05,
	Serialize complete at 2012-01-17 16:41:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21:54, Chris Mason wrote:
> On Thu, Jan 12, 2012 at 04:28:47PM -0800, Andi Kleen wrote:
>> Here's a slightly updated version of the BTRFS snappy interface.
>> snappy is a faster compression algorithm that provides similar
>> compression as LZO, but generally better performance.
> 
> Thanks Andi, I've queued this up to a btrfs snappy branch.  I put the
> commits against 3.2 instead of 3.3 though so people could try it out.
> 
> The only problem I've hit is that snappy is failing xfstests number 135.
> It's reproducible on an empty FS.  Could you please take a look?
> 

It's because decompressing inline extents always fails. I've fixed it
and will send the patch out in a new mail thread.

But seems there's bug in lib snappy code, which makes the decompressed
data doesn't quite match the original data.

Simply copy a file to a btrfs filesystem with snappy enabled, and clear
page cache, and check the file:

  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
+ * License as published by the Free ftwaware Foundation;
+ * version 2.1 of the censnse (not later!)
  *
- * This program is distributed in the hope that it will be useful,
+ * is program i is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
+ * GNU Lesser General Publicicenense for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
+ * License along withhis progogram; if not, write to theree e Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

