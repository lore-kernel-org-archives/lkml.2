Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1KGPTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:19:44 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:38290 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1KGPTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:19:43 -0500
Date: Mon, 7 Nov 2011 10:19:39 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data
 in fill_super and remount.
Message-ID: <20111107151939.GA24234@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 11:01:51PM +0900, Namjae Jeon wrote:
> Fix NULL pointer dereference from orig_data in fill_super and remount.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

Um, did you even try to test this patch before submitting it?

#1:   kstrdup() return NULL if data is NULL

#2:  The kernel's printk and sprintf functions will translate
     sprintf(buf, "%s", NULL) by filling in the string "NULL"

#3:  The only use of orig_data is a cosmetic one, of printing out
     the mount options which are passed in.

#4:  If the user doesn't specify any mount options, data is NULL, and
     your patch would cause those mounts to fail with ENOMEM.

In summary, there is no problem here; a pendant might complain that
it's possible for data to be non-NULL, and for orig_data to be null of
the kstrdup failed, but in that case, other memory allocations done
later in ext4_fill_super() will almost have certainly failed, so in
practice won't get as far as the printk.

					- Ted
