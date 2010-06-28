Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0F1REN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:04:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60978 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0F1REL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M6aW0gaZPlfbmbkTZRNhwF5FZfBRnSAz34s+Tir6DhKc+b9tXOq0FR4ERrhlrLdRWp
         KxiRvAXDAcKjSC56VGPDxOLirvBq7J2zG/dDUuYcVH8Ij8ko0Bl4rcmBqreTlxbK2yC3
         O+56Q25BQvOOD4cpZuUFovkDJf94i7VXMQ/68=
MIME-Version: 1.0
In-Reply-To: <20100628164854.GA9979@samba1>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
	<AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
	<20100628164854.GA9979@samba1>
Date: Mon, 28 Jun 2010 12:04:09 -0500
Message-ID: <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA@mail.gmail.com>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation 
	available by xattrs
From: Steve French <smfrench@gmail.com>
To: Jeremy Allison <jra@samba.org>
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:48 AM, Jeremy Allison <jra@samba.org> wrote:
> On Mon, Jun 28, 2010 at 11:33:10AM -0500, Steve French wrote:
>>
>> It would be easy enough to do something similar for crtime for cifs
>> (it may also be possible to do something similar to
>> i_generation and i_version at least for smb2 but haven't
>> experimented to see which servers could return something
>> similar to version and generation).  I did have a request for
>> someone doing a backup application over cifs to return creation
>> time so at least this would make sense.
>
> We already have code in Samba to detect "birthtime"
> (st_btime) as a returned member of a stat struct.
>
> This already works on many other platforms, so I'd
> rather just have Linux stat fixed to work with
> btime.

That sounds better but it hits the fs, vfs and libc
and seems like libc is near impossible to get changes into.
Seems like in the short term adding xattrs is harmless, and
doesn't hurt in the longrun


-- 
Thanks,

Steve
