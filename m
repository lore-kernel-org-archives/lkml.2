Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1ISJbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:31:22 -0400
Received: from www17.your-server.de ([213.133.104.17]:43028 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1ISJbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:31:21 -0400
References: <1316167604.6545.84.camel@localhost.localdomain> <20110916101903.GI2203@ZenIV.linux.org.uk> <1316169496.8502.6.camel@perseus.themaw.net> <1316332908.5814.22.camel@localhost.localdomain> <1316404368.3206.21.camel@perseus.themaw.net> <20110919061059.GJ2203@ZenIV.linux.org.uk>
In-Reply-To: <20110919061059.GJ2203@ZenIV.linux.org.uk>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <CACCE520-D261-4B97-B208-1C44574886BF@m3y3r.de>
Content-Transfer-Encoding: 8BIT
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH] Force same size of struct autofs_v5_packet on x86 and x86_64
Date: Mon, 19 Sep 2011 11:30:42 +0200
To: Al Viro <viro@ZenIV.linux.org.uk>, Ian Kent <raven@themaw.net>
X-Mailer: Apple Mail (2.1084)
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 19.09.2011 um 08:10 schrieb Al Viro:

> On Mon, Sep 19, 2011 at 11:52:48AM +0800, Ian Kent wrote:
> 
>>> btw. where are the padding bytes are added? how to tell gcc to display
>>> this?
>> 
>> It's also been a long time since I looked into this so I don't remember
>> the processor alignment details.
>> 
>> Not sure if there is a compiler option that would report this, sorry,
>> anyone else?
> 
> Padding is added in the very end.  The thing is, it's not a misaligned
> field per se; they all have a natural alignment in there.  It's that
> __u64 ino has alignment 8 on amd64 and alignment 4 on i386.  So the alignment
> requirements for the entire structure are different - on amd64 the address
> of the entire thing must be a multiple of 8 and on i386 it can be any multiple
> of 4.  IOW, on i386 you can just put them one after another in e.g. an array
> (the size without any padding is 300 bytes) and on amd64 you need 4 bytes
> of padding added between them.  I.e. sizeof needs to go up by 4, with the
> padding added in the end.

okay. that's what I thought.

@Ian: Is the read() from the pipe fd the only way to consume this structure from userspace?

if so: why not align the size of this structure for x86 and x86_64 to the same size?

the systemd compiled for x86_64 will probably work with this change, but does maybe report something like a short read or so, as it currently expects 304 bytes to read.
i didn't test this yet.

@al: what other autofs4 users are out there besides systemd?

with kind regards
thomas