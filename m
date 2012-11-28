Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2K1RpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:45:24 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:35488 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab2K1RpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:45:21 -0500
Date: Wed, 28 Nov 2012 12:45:15 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Vahram Martirosyan <vmartirosyan@gmail.com>
Cc: Vahram Martirosyan <vmartirosyan@linuxtesting.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fixed ext4_calculate_overhead() bug.
Message-ID: <20121128174515.GC24431@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Vahram Martirosyan <vmartirosyan@gmail.com>,
	Vahram Martirosyan <vmartirosyan@linuxtesting.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1353544101-5154-1-git-send-email-vmartirosyan@linuxtesting.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353544101-5154-1-git-send-email-vmartirosyan@linuxtesting.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:28:21PM -0800, Vahram Martirosyan wrote:
> The memset operation before check brings to a BUG.
> No need to memset the page with zeroes.
> 
> The patch removes the memset call in ext4_calculate_overhead() function.
> 
> Found by the Spruce system in cooperation with the KEDR Framework.
> 
> Signed-off-by: Vahram Martirosyan <vmartirosyan@linuxtesting.org>

Applied, with a slightly rewritten commit description:

    ext4: fixed potential NULL dereference in ext4_calculate_overhead()
    
    The memset operation before check can cause a BUG if the memory
    allocation failed.  Since we are using get_zeroed_age, there is no
    need to use memset anyway.
    
    Found by the Spruce system in cooperation with the KEDR Framework.
    
    Signed-off-by: Vahram Martirosyan <vmartirosyan@linuxtesting.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
