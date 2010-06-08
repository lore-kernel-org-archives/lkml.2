Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0FHLOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:14:06 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:60207 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab0FHLOF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:14:05 -0400
X-AuditID: 12074424-b7b9dae000002832-ad-4c0e25fa321c
Subject: Re: EXT3 File System Corruption 2.6.34
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTik4BmOSZ9xqsMcMVN_fkB79ySGQVVK56i1xUmFt@mail.gmail.com>
Date: Tue, 8 Jun 2010 07:14:03 -0400
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7707881C-9879-4531-8DE9-EEED2F4534E5@mit.edu>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com> <4C0D5DCD.5010201@sandeen.net> <AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com> <AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com> <889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net> <AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com> <C4177A0B-9A74-40E6-9A58-64418034232C@sandeen.net> <AANLkTinzZkN9agekI5eqzA9hERsghI7yDJyAy1O755dr@mail.gmail.com> <AANLkTik4BmOSZ9xqsMcMVN_fkB79ySGQVVK56i1xUmFt@mail.gmail.com>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7, 2010, at 10:14 PM, Jeffrey Merkey wrote:

> From: Jeffrey Merkey <jeffmerkey@gmail.com>
> Date: Mon, Jun 7, 2010 at 8:13 PM
> Subject: Re: EXT3 File System Corruption 2.6.34
> To: Eric Sandeen <sandeen@sandeen.net>
> 
> 
> Well, I will set this as default from now on.  Tell Evil Emperor Linus
> to put the fucking thing back the way it was so default kernel builds
> are not fucked up.

If you pull the plug without fsyncing the file, you will end up with a zero-length file -- or possibly no file at all, even with data=ordered.  If you really want to preserve data after pulling the power cord immediately after a write were the application hasn't done an fsync() or a sync() call, you can mount the file system with the mount option -o sync --- but then the performance will be horrible.

It's all a tradeoff of what you think is important....

-- Ted

