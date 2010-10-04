Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0JDRds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:33:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60378 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0JDRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:33:46 -0400
Date: Mon, 4 Oct 2010 18:33:43 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: overlayfs: BUG in ovl_whiteout
Message-ID: <20101004173343.GA19733@agent57>
References: <20101001180702.GD2832@shadowen.org>
 <E1P2hGO-0001kL-Gw@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P2hGO-0001kL-Gw@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 11:23:16AM +0200, Miklos Szeredi wrote:
> On Fri, 1 Oct 2010, Andy Whitcroft wrote:
> > I have been playing with overlayfs for a bit now and there seems to
> > be something a little dodgy when unmounting and remounting an overlay.
> > I modified some files in the overlay, immediatly unmounted the overlay and
> > again immediatly remounted it.  On touching the same files in the overlay
> > I triggered the following BUG (dmesg fragment at the bottom of this email).
> > When trying to reproduce this I also triggered a hard hang.
> 
> Thanks for the bug report, Andy.
> 
> Please change that BUG_ON to a WARN_ON.  This will make this a
> harmless error message in the log instead of a hang.

Applied your patch to move these to WARN_ON.  Now I get a WARN_ON after
the remount.  Now that we don't explode I get the following error from
the triggering command.  I assume that this is the rename which has
triggered the issue:

W: Failed to fetch http://192.168.0.60:3142/archive.ubuntu.com/ubuntu/dists/maverick/Release rename failed, File exists (/var/lib/apt/lists/192.168.0.60:3142_archive.ubuntu.com_ubuntu_dists_maverick_Release -> /var/lib/apt/lists/192.168.0.60:3142_archive.ubuntu.com_ubuntu_dists_maverick_Release).

I note that the file does indeed exist as a real file in both layers.  I
have not as yet managed to generate a naive test that also triggers
this.

-apw
