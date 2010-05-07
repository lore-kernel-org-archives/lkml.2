Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0EGIDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:03:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63661 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab0EGIDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R26j6oQ1vQWCJOs7TlbD0J44ay3BD2rrVgqN/G5wOE921+e666480seGeg55Qz3O/g
         4nPc8osLGcNc9JGaSEtBovTcC25rHMCc+hPKfSYwpa+NEF56YTiWz+YpQFlMGWFB4not
         Dm6Z7pHa1LQsvdgGUJ87z1lyU8QtdPc1WO08k=
MIME-Version: 1.0
In-Reply-To: <1273217107-2023-2-git-send-email-ngupta@vflare.org>
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
	 <1273217107-2023-2-git-send-email-ngupta@vflare.org>
Date: Fri, 7 May 2010 17:03:38 +0900
Message-ID: <y2m1b68c6791005070103q8cabf3afx22af4a28c6ecf747@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add flag to identify block swap devices
From: jassi brar <jassisinghbrar@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 4:25 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Added SWP_BLKDEV flag to distinguish block and regular file backed
> swap devices. We could also check if a swap is entire block device,
> rather than a file, by:
> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
> but, I think, simply checking this flag is more convenient.
This might make it convenient for now but is likely to increase complexity and
redundancy. Why not define a macro/inline to figure that out?
