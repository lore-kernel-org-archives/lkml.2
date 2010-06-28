Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab0F1QdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:33:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41740 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0F1QdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XQPdd1AObGkHHUUVj2/rUHFj/R7E98oYQ3xCmdyWvpBGuzEWiQGoJ/CoNx9EH4bVuY
         IXYbx43jPY+I8Hw1/N4fZbaKI0j8lZMDcPiPE88x8SfmPErzDL9dVyFkUBD/R0jB2HRm
         raXcwA0J5HZWPsIkBCti9aAQiJg9nv9QQIkcM=
MIME-Version: 1.0
In-Reply-To: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
Date: Mon, 28 Jun 2010 11:33:10 -0500
Message-ID: <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation 
	available by xattrs
From: Steve French <smfrench@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, jlayton@redhat.com, mcao@us.ibm.com,
       aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, sjayaraman@suse.de,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:26 AM, David Howells <dhowells@redhat.com> wrote:
> Make the file creation time, inode data version number and inode generation
> number available on Ext4 by as xattrs named:
>
>        file.crtime
>        file.i_generation
>        file.i_version (directories only for ext4)
>
> This could then be used by Samba as the SMB protocol passes the file creation
> time to the client.
>
> With this patch, you can see the xattrs providing binary data:
>
> [root@andromeda ~]# getfattr -d /var/cache/fscache -e hex -m\.*
> getfattr: Removing leading '/' from absolute path names
> # file: var/cache/fscache
> file.crtime=0x53ba244c000000000000000000000000
> file.i_generation=0x0000000000000000
> file.i_version=0x0400000000000000

It would be easy enough to do something similar for crtime for cifs
(it may also be possible to do something similar to
i_generation and i_version at least for smb2 but haven't
experimented to see which servers could return something
similar to version and generation).  I did have a request for
someone doing a backup application over cifs to return creation
time so at least this would make sense.


-- 
Thanks,

Steve
