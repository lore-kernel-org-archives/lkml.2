Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1AJRwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:52:44 -0500
Received: from THUNK.ORG ([69.25.196.29]:45448 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1AJRwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:52:43 -0500
Date: Mon, 10 Jan 2011 12:52:34 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Hugh Dickins <hughd@google.com>
Cc: Amir Goldstein <amir73il@users.sf.net>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: ext4: ext23 support leaks buffer pages
Message-ID: <20110110175234.GD3128@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>,
	Amir Goldstein <amir73il@users.sf.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <alpine.LSU.2.00.1101100242530.2000@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1101100242530.2000@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 02:54:26AM -0800, Hugh Dickins wrote:
> I switched to CONFIG_EXT4_USE_FOR_EXT23=y with 2.6.37, but was
> then surprised by OOM kills: 2.6.36 and current are also bad.

Oops.  Yeah, the problem was when ext4_forget() was moved out of
ext4_free_branches, we needed to replace it with a call to brelse().
Thanks for pointing this out.

Patch follows...

					- Ted
