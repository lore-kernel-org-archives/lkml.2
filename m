Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1CYLid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:38:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34836 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1CYLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HorqzGTCWHfSH35m2aqIp7+Hcponxj9RsOlbjmZrkvQq2G2d+0Gu7NKoZa9FDpW+54
         A5JJYognW3DRcNi5m/8L7FmssN1/BZJa5ZtHte/rNHM8b7k2RhU2QuIZuanh/sCFPYm8
         2qLhScwVYAWvjrXQrT/dS0/82+h1gIHukvMjM=
MIME-Version: 1.0
In-Reply-To: <4D8B4A6F.9040303@redhat.com>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
	<AANLkTim7q5L9v5uFx9NB2Eai48WCTi5sSSx9yFbQgszi@mail.gmail.com>
	<4D8B4A6F.9040303@redhat.com>
Date: Fri, 25 Mar 2011 12:38:28 +0100
X-Google-Sender-Auth: eRXxf3OS-CtrKXa7C76BzMKusI0
Message-ID: <AANLkTikGybr-iynMG3T0TwY0aRSbMdDDB+D8QFnWgwA7@mail.gmail.com>
Subject: Re: Union mounts comparison with overlay file system prototype?
From: Szeredi Miklos <miklos@szeredi.hu>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Valerie Aurora <valerie.aurora@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 2:43 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> Can one or both of you summarize what we union mounts and overlay do better
> or worse? Do we need both or just one?

The semantics are very similar, the differences are in the implementation.

Union mounts:

 - whiteout/opaque/fallthrough support in filesystems
 - whiteout operation is atomic
 - no dentry and inode duplication
 - copy up on lookup and readdir
 - does not support union of two read-only trees
 - merged directory stored in upper tree

Overlayfs

- whiteout/opaque as xattrs
- whiteout operation is not atomic
- dentry and inode duplication(*)
- only copy up on modification
- supports union of two read-only trees
- merged directory not cached(**)

(*) it's possible to eliminate inode duplication of non-directories
with some VFS modifications
(**) caching should be possible to do
