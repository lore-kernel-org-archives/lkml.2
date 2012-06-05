Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2FEUmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:42:06 -0400
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:58668
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2FEUmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:42:04 -0400
Date: Tue, 5 Jun 2012 22:41:54 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1018371644.20120605224154@eikelenboom.it>
To: Kees Cook <keescook@chromium.org>
CC: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        <dm-devel@redhat.com>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
In-Reply-To: <20120605000356.GM29466@outflux.net>
References: <471046920.20120604234941@eikelenboom.it> <20120605000356.GM29466@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday, June 5, 2012, 2:03:56 AM, you wrote:

> Hi,

> On Mon, Jun 04, 2012 at 11:49:41PM +0200, Sander Eikelenboom wrote:
>> I have enabled some debug options, this is from around when the error occurs (kernel: [  950.610126] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1699, 32254 clusters in bitmap, 32258 in gd)

> Today I've finally managed to bisect this to here:
> [fd034a84e1ea5c8c8d159cd2089c32e792c269b0] ext4: split out ext4_free_blocks_after_init()

> If I revert all the "ext4:" patches in 3.2 up to and including that one,
> I get normal behavior again.

Hmm that seems consistent with this report which mentions 3.1.5 as last working kernel:
http://comments.gmane.org/gmane.comp.file-systems.ext4/30575

So somehow this only effects ext4 on DM (it's THE common factor in all reports) and fsck seems incapable of seeing the error (and thus repair it.)

--
Sander

> -Kees

