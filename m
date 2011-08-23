Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab1HWMwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:52:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HWMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:52:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/7] VFS: Add generic_file_llseek_size
Date: Tue, 23 Aug 2011 14:51:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1314046152-2175-1-git-send-email-andi@firstfloor.org> <1314046152-2175-5-git-send-email-andi@firstfloor.org>
In-Reply-To: <1314046152-2175-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231451.56191.arnd@arndb.de>
X-Provags-ID: V02:K0:IfIXbqLED/0JkS5KwfDYTC/UEXxYArzVJtNQVbuiy3b
 erI3lalqqgJQHWJxztG3FXjN+SWUwYH3JfmqPUW0TqncO8269/
 TXRCVTuAlFJbC0ug9ndxZ4FC8ZQx5dTZUhJxGkz91Oz87FNaBT
 rKMfvxBTYRs9i3zC/OPYuS0+0W447lvQLAH4/gjn1kav2J8qDQ
 g7QBuQHQpt1OT4YJPAsDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 August 2011, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a generic_file_llseek variant to the VFS that allows passing in
> the current file size, instead of always using inode->i_size.
> This can be used to eliminate some cut'n'paste seek code in ext4.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Ah, very nice. I think you can use the same trick to remove duplication
in default_llseek by always setting the limit to MAX_LFS_FILESIZE.

	Arnd
