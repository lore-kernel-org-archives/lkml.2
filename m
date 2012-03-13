Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2CMLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:16:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49112 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2CMLQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:16:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
        sfrench@samba.org, sage@newdream.net, ericvh@gmail.com
Subject: Re: [PATCH 05/25] vfs: add filesystem flags for atomic_open
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-6-git-send-email-miklos@szeredi.hu>
	<20120313093302.GA11797@infradead.org>
Date: Tue, 13 Mar 2012 12:17:08 +0100
In-Reply-To: <20120313093302.GA11797@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Mar 2012 05:33:02 -0400")
Message-ID: <87pqcg92dn.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Mar 07, 2012 at 10:22:22PM +0100, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>> 
>> Allow filesystem to select which cases it wants to perform atomic_open.
>
> Given that atomic_open is allowed to return a NULL filp and fall back to
> the traditional open I don't think this is needed - it can be much
> cleaner handled by the fs just returning NULL for that case.

Hmm, yeah.  The reason I did this was to prevent doing permission/
security checks twice before create.

But in fact that could be optimized away with careful code flow.  I'll
look into dropping this.

Thanks,
Miklos
