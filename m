Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2BFHhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:37:11 -0500
Received: from 1wt.eu ([62.212.114.60]:62247 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2BFHhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:37:09 -0500
Date: Mon, 6 Feb 2012 08:37:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 55/91] Make scsi_free_queue() kill pending SCSI commands
Message-ID: <20120206073701.GI8334@1wt.eu>
References: <0635750f5f06ed2ca212b91fcb5c4483@local> <20120205220951.802368623@pcw.home.local> <CAO+b5-pNeQmzNh_tfxumTnJa6w0g9dg-DuAY893KgwKPnBgjMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO+b5-pNeQmzNh_tfxumTnJa6w0g9dg-DuAY893KgwKPnBgjMg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 08:28:48AM +0100, Bart Van Assche wrote:
> On Sun, Feb 5, 2012 at 11:10 PM, Willy Tarreau <w@1wt.eu> wrote:
> >
> > 2.6.27-longterm review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > commit 3308511c93e6ad0d3c58984ecd6e5e57f96b12c8 upstream.
> >
> > Make sure that SCSI device removal via scsi_remove_host() does finish
> > all pending SCSI commands. Currently that's not the case and hence
> > removal of a SCSI host during I/O can cause a deadlock. See also
> > "blkdev_issue_discard() hangs forever if underlying storage device is
> > removed" (http://bugzilla.kernel.org/show_bug.cgi?id=40472). See also
> > http://lkml.org/lkml/2011/8/27/6.
> 
> If you backport that commit, you should backport commit
> 745718132c3c7cac98a622b610e239dcd5217f71 too. See e.g.
> http://lkml.org/lkml/2011/11/8/22.

Thank you Bart, I thought it was just cosmetic. Queued now.

Cheers,
Willy

