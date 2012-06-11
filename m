Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2FKQci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:32:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41910 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FKQcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:32:35 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
	<20120610034921.GB30000@ZenIV.linux.org.uk>
Date: Mon, 11 Jun 2012 18:33:20 +0200
In-Reply-To: <20120610034921.GB30000@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 10 Jun 2012 04:49:21 +0100")
Message-ID: <87y5ntg65r.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't like this:

    make ->atomic_open() return int
    
    Change of calling conventions:
    old         new
    NULL                1
    file                0
    ERR_PTR(-ve)        -ve
    
    Caller *knows* that struct file *; no need to return it.

Yes, ordinary filesystems the caller knows the 'struct file *' but for
overlayfs (and stacking in general) wants to be able to return a file
obtained by opening the file on another filesystem.

Thanks,
Miklos

