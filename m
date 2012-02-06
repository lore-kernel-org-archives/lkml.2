Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2BFH2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:28:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62584 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2BFH2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:28:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120205220951.802368623@pcw.home.local>
References: <0635750f5f06ed2ca212b91fcb5c4483@local>
	<20120205220951.802368623@pcw.home.local>
Date: Mon, 6 Feb 2012 08:28:48 +0100
X-Google-Sender-Auth: iVKjnjmB_1_Ks1xwFK6PBFC51yo
Message-ID: <CAO+b5-pNeQmzNh_tfxumTnJa6w0g9dg-DuAY893KgwKPnBgjMg@mail.gmail.com>
Subject: Re: [PATCH 55/91] Make scsi_free_queue() kill pending SCSI commands
From: Bart Van Assche <bvanassche@acm.org>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 11:10 PM, Willy Tarreau <w@1wt.eu> wrote:
>
> 2.6.27-longterm review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> commit 3308511c93e6ad0d3c58984ecd6e5e57f96b12c8 upstream.
>
> Make sure that SCSI device removal via scsi_remove_host() does finish
> all pending SCSI commands. Currently that's not the case and hence
> removal of a SCSI host during I/O can cause a deadlock. See also
> "blkdev_issue_discard() hangs forever if underlying storage device is
> removed" (http://bugzilla.kernel.org/show_bug.cgi?id=40472). See also
> http://lkml.org/lkml/2011/8/27/6.

If you backport that commit, you should backport commit
745718132c3c7cac98a622b610e239dcd5217f71 too. See e.g.
http://lkml.org/lkml/2011/11/8/22.

Bart.
