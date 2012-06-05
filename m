Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250Ab2FEAEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:04:05 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34863 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab2FEAEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:04:04 -0400
Date: Mon, 4 Jun 2012 17:03:56 -0700
From: Kees Cook <keescook@chromium.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        dm-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group
 1904, 32254 clusters in bitmap, 32258 in gd
Message-ID: <20120605000356.GM29466@outflux.net>
References: <471046920.20120604234941@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471046920.20120604234941@eikelenboom.it>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 04, 2012 at 11:49:41PM +0200, Sander Eikelenboom wrote:
> I have enabled some debug options, this is from around when the error occurs (kernel: [  950.610126] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1699, 32254 clusters in bitmap, 32258 in gd)

Today I've finally managed to bisect this to here:
[fd034a84e1ea5c8c8d159cd2089c32e792c269b0] ext4: split out ext4_free_blocks_after_init()

If I revert all the "ext4:" patches in 3.2 up to and including that one,
I get normal behavior again.

-Kees

-- 
Kees Cook
ChromeOS Security
