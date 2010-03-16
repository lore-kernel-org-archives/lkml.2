Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0CPTOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:14:11 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:63827 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0CPTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=blxnJvZwcp80MeUphm3FQ192xCUdEy5e7WArUV4vDkZqiy9bUdsBrLqCCKJS3VEw3Y
         i6+0TcniFClflLnHQdbIfPYt2ZgvQMPBIGso0dSxrM0JLG+ya47RvGP3j7Q9x6qzsZ9f
         TXgMjA7/fh1833Ji8I0RM1DAjm7j92L9Er4yM=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Greg KH <greg@kroah.com>
Cc: kay.sievers@vrfy.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: support !CONFIG_TMPFS
References: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
	<20100316190005.GA32555@kroah.com>
Date: Tue, 16 Mar 2010 20:14:05 +0100
In-Reply-To: <20100316190005.GA32555@kroah.com> (Greg KH's message of "Tue, 16
	Mar 2010 12:00:05 -0700")
Message-ID: <87wrxcgjuq.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Greg" == Greg KH <greg@kroah.com> writes:

Hi,

 >> config DEVTMPFS
 >> bool "Maintain a devtmpfs filesystem to mount at /dev"
 >> -	depends on HOTPLUG && SHMEM && TMPFS
 >> +	depends on HOTPLUG
 >> help
 >> This creates a tmpfs filesystem instance early at bootup.
 >> In this filesystem, the kernel driver core maintains device

 Greg> With this patch, the Kconfig help text now is incorrect.

 Greg> Is there a way to explicitly call out in the Kconfig which way
 Greg> devtmpfs is being created?  How about a multiple selection that
 Greg> chooses either TMPFS or RAMFS, with the default being TMPFS?

I don't think that's needed - If CONFIG_TMPFS isn't set, then ramfs
pretends to be tmpfs anyway, see mm/shmem.c:

static struct file_system_type tmpfs_fs_type = {
	.name		= "tmpfs",
	.get_sb		= ramfs_get_sb,
	.kill_sb	= kill_litter_super,
};

So calling it tmpfs isn't really wrong.

 Greg> So care to redo this so that people can easily determine what is going
 Greg> to happen easier than this patch currently causes?

We can change the help text to say tmpfs/ramfs if you prefer - OK?

-- 
Bye, Peter Korsgaard
