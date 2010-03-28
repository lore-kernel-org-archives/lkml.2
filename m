Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0C1WJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 18:09:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44394 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab0C1WJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 18:09:00 -0400
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tytso@mit.edu, npiggin@suse.de, mingo@elte.hu,
       Ruald Andreae <ruald.a@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Olly Betts <olly@survex.com>, martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
From: Andi Kleen <andi@firstfloor.org>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<4baeaee5.c5c2f10a.7187.2688@mx.google.com>
	<20100327204233.0d84542a@infradead.org>
	<4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com>
Date: Mon, 29 Mar 2010 00:08:58 +0200
In-Reply-To: <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com> (Ben Gamari's message of "Sun, 28 Mar 2010 07:06:04 -0700 (PDT)")
Message-ID: <87y6hcyu85.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gamari <bgamari.foss@gmail.com> writes:

You don't say which file system you use, but ext3 and the file systems
with similar journal design (like reiserfs) all have known fsync starvation
issues. The problem is that any fsync has to wait for all transactions
to commit, and this might take a long time depending on how busy
the disk is.

ext4/XFS/JFS/btrfs should be better in this regard

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
