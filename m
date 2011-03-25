Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab1CYMMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1CYMMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:12:50 -0400
Message-ID: <4D8C86B2.2060902@redhat.com>
Date: Fri, 25 Mar 2011 08:12:34 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Szeredi Miklos <miklos@szeredi.hu>
CC: Valerie Aurora <valerie.aurora@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Union mounts comparison with overlay file system prototype?
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>	<AANLkTim7q5L9v5uFx9NB2Eai48WCTi5sSSx9yFbQgszi@mail.gmail.com>	<4D8B4A6F.9040303@redhat.com> <AANLkTikGybr-iynMG3T0TwY0aRSbMdDDB+D8QFnWgwA7@mail.gmail.com>
In-Reply-To: <AANLkTikGybr-iynMG3T0TwY0aRSbMdDDB+D8QFnWgwA7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2011 07:38 AM, Szeredi Miklos wrote:
> On Thu, Mar 24, 2011 at 2:43 PM, Ric Wheeler<rwheeler@redhat.com>  wrote:
>> Can one or both of you summarize what we union mounts and overlay do better
>> or worse? Do we need both or just one?
> The semantics are very similar, the differences are in the implementation.
>
> Union mounts:
>
>   - whiteout/opaque/fallthrough support in filesystems
>   - whiteout operation is atomic
>   - no dentry and inode duplication
>   - copy up on lookup and readdir
>   - does not support union of two read-only trees
>   - merged directory stored in upper tree
>
> Overlayfs
>
> - whiteout/opaque as xattrs
> - whiteout operation is not atomic
> - dentry and inode duplication(*)
> - only copy up on modification
> - supports union of two read-only trees
> - merged directory not cached(**)
>
> (*) it's possible to eliminate inode duplication of non-directories
> with some VFS modifications
> (**) caching should be possible to do

Thanks for the high level overview!

Ric

