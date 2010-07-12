Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0GLRFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:05:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58400 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0GLRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:05:36 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: miklos@szeredi.hu, hch@infradead.org, viro@zeniv.linux.org.uk,
        adilger@sun.com, corbet@lwn.net, neilb@suse.de, npiggin@suse.de,
        hooanon05@yahoo.co.jp, bfields@fieldses.org,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <87aapxyniq.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [PATCH -V16 07/12] vfs: Support null pathname in linkat
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1OYE1D-0005qC-AI@pomaz-ex.szeredi.hu> <87aapxyniq.fsf@linux.vnet.ibm.com>
Message-Id: <E1OYMRK-00070W-Qn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 19:05:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K. V wrote:
> /*
>  * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
>  * otherwise has the potential to corrupt the orphan inode list.
>  */
> if (inode->i_nlink == 0)
> 	return -ENOENT;
> 
> I can move this check to VFS so that we do it for all file systems. 

That makes sense.  Hopefully filesystems which implement hard links
will change i_nlink to zero for the last unlink...

Thanks,
Miklos
