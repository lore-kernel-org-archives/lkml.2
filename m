Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1HQDMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 23:12:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62354 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1HQDM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 23:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110817021820.GU2203@ZenIV.linux.org.uk>
References: <20110816164809.GE2227@zod.bos.redhat.com>
	<20110817021820.GU2203@ZenIV.linux.org.uk>
Date: Tue, 16 Aug 2011 23:12:27 -0400
X-Google-Sender-Auth: mAJ5-zswmVpuKKXUdiModwj-Uxk
Message-ID: <CAEKwDSC0kEATJ2VoKR7HvE+V6rizKm+r0+-p2=vQ=m0FAFa0YQ@mail.gmail.com>
Subject: Re: Oops in minixfs_statfs
From: Bob Copeland <me@bobcopeland.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 10:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> I *think* that what's happening in your case is that we have more blocks
> for block bitmap than we would need to hold all bits.  That would explode
> in exactly such a way, but I'd like to see confirmation; what arguments
> does your count_free() actually get?  The last two arguments, that is...

Sounds like it, Josh posted this output before:

[  516.859103] imap_blocks 7 zmap_blocks 7 firstdatazone c11
log_zone_size 0 max_size 7fffffff magic 4d5a nzones 3001c blocksize:
1000

So there are 7 blocks in the zone bitmap but only 0x3001c - 0xc11 = 193547
zones to allocate, which would fit in 6 blocks.

-- 
Bob Copeland %% www.bobcopeland.com
