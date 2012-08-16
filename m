Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776Ab2HPODJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:03:09 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59052 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab2HPODE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:03:04 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Pavel Emelianov <xemul@parallels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Thread-Topic: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Thread-Index: AQHNese8v4CCEaSMdUyq8H0F5S5OkpdbzawAgAAEtoCAABHRgIAAi0EAgABoVgCAABJHgIAAAPcAgAAA5oCAAAFBAIAAAkmA
Date: Thu, 16 Aug 2012 14:03:00 +0000
Message-ID: <1345125779.3259.50.camel@dabdike.int.hansenpartnership.com>
References: <20120815092116.700948346@openvz.org>
	 <20120815092409.591460800@openvz.org> <20120815204546.GC25062@fieldses.org>
	 <20120815210237.GF25421@moon> <20120815220622.GA28054@fieldses.org>
	 <20120816062448.GA32081@moon> <20120816123814.GD1209@moon>
	 <20120816134339.GQ23464@ZenIV.linux.org.uk>
	 <502CF9DA.8030701@parallels.com>
	 <20120816135019.GS23464@ZenIV.linux.org.uk> <20120816135448.GP32081@moon>
In-Reply-To: <20120816135448.GP32081@moon>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [87.194.65.0]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCC72CA5ACA0CC4A873A5A8D20152818@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7GE3GYF028074

On Thu, 2012-08-16 at 17:54 +0400, Cyrill Gorcunov wrote:
> On Thu, Aug 16, 2012 at 02:50:19PM +0100, Al Viro wrote:
> > On Thu, Aug 16, 2012 at 05:47:06PM +0400, Pavel Emelyanov wrote:
> > > On 08/16/2012 05:43 PM, Al Viro wrote:
> > > > On Thu, Aug 16, 2012 at 04:38:14PM +0400, Cyrill Gorcunov wrote:
> > > > 
> > > >> Hi Bruce, thinking a bit more I guess using general encode_fh is not that
> > > >> convenient since it operates with dentries while our fdinfo output deals
> > > >> with inodes. Thus I should either provide some new encode_fh variant
> > > >> which would deal with inodes directly without "parents". Which doesn't
> > > >> look for me anyhow better than the new export_encode_inode_fh helper.
> > > > 
> > > > Huh?  You do have dentries, for crying out loud...
> > > 
> > > Sometimes we don't -- the inotify thing gets an inode only.
> > > Unlike other notifies that have dentries at hands...
> > 
> > What's wrong with saying "we don't support idiotify"?
> 
> Al, we need some way to restore inotifies after checkpoint.
> At the very early versions of these patches I simply added
> dentry to the inotify mark thus once inotify created we always
> have a dentry to refer on in encode_fh, but I'm not sure if
> this will be good design.

Actually, I was about to suggest this.  This can be done internally
within fs/notify without actually modifying the syscall interface, can't
it, since they take a path which is used to obtain the inode?  It looks
like the whole of the inotify interface could be internally recast to
use dentries instead of inodes.  Unless I've missed something obvious?

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
