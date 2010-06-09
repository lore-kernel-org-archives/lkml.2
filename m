Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0FIAti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 20:49:38 -0400
Received: from mail.lang.hm ([64.81.33.126]:52159 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab0FIAth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 20:49:37 -0400
Date: Tue, 8 Jun 2010 17:49:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
cc: Theodore Tso <tytso@MIT.EDU>, Jeffrey Merkey <jeffmerkey@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: EXT3 File System Corruption 2.6.34
In-Reply-To: <4C0E469E.7030808@gmail.com>
Message-ID: <alpine.DEB.2.01.1006081747430.17462@asgard.lang.hm>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com> <4C0D5DCD.5010201@sandeen.net> <AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com> <AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com> <889B6B31-A1F0-438D-B782-DBB855912
 <7707881C-9879-4531-8DE9-EEED2F4534E5@mit.edu> <4C0E469E.7030808@gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, T?r?k Edwin wrote:

> On 06/08/2010 02:14 PM, Theodore Tso wrote:
>>
>> If you pull the plug without fsyncing the file, you will end up with a zero-length file -- or possibly no file at all, even with data=ordered.  If you really want to preserve data after pulling the power cord immediately after a write were the application hasn't done an fsync() or a sync() call, you can mount the file system with the mount option -o sync --- but then the performance will be horrible.
>>
>> It's all a tradeoff of what you think is important....
>>
>
> I think you should either get the old file, or the new file (if you
> don't fsync), and not some random data from another file.

my understanding of the way to get what you want is to

write tempfile
sync
mv temptfile realfile

this also has the advantage that it will work on all filesystems.

David Lang
