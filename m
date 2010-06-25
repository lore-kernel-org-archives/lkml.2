Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0FYMo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:44:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:51036 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0FYMoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:44:25 -0400
Message-ID: <4C24A4A0.90408@suse.de>
Date: Fri, 25 Jun 2010 18:14:16 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index
 objects and register them
References: <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com>
In-Reply-To: <9720.1277312290@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 10:28 PM, David Howells wrote:
> Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
>> Define superblock-level cache index objects (managed by cifsTconInfo
>> structs).  Each superblock object is created in a server-level index object
>> and in itself an index into which inode-level objects are inserted.
>>
>> Currently, the superblock objects are keyed by sharename.
> 
> Seems reasonable.  Is there any way you can check that the share you are
> looking at on a server is the same as the last time you looked?  Can you

Good point.

I thought of using TID (Tree identifier; a unique ID for a resource in
use by client) along with sharename. But, Server is free to reuse them
when the tree connection closes and does not guarantee the same Tid for
a particular resource across tree connections.

Also, considering the UNC name of the resource (//server/share) may not
be a good idea too as the cache will not be used when for e.g. IPaddress
is used to mount.

So, if a server does something like this:
   - export a share 'foo' (original server path: /export/vol1/foo)
   - client mounts and uses it
   - server unexports the share 'foo'
   - server exports 'foo' (original sever path: /export/vol2/foo)

we have a bit of problem..

> validate the root directory of the share in some way?
> 

I don't know if there is a way to do this.

Thanks,


-- 
Suresh Jayaraman
