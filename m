Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1KRUZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:25:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38962 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1KRUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:25:54 -0500
Date: Fri, 18 Nov 2011 20:25:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] pipe: Fail cleanly when root tries F_SETPIPE_SZ with big
 size
Message-ID: <20111118202552.GB2203@ZenIV.linux.org.uk>
References: <1321646674-26890-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321646674-26890-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 10:04:34PM +0200, Sasha Levin wrote:

> +	if (nr_pages * sizeof(struct pipe_buffer) > KMALLOC_MAX_SIZE)
> +		return -ENOMEM;

nr_pages is unsigned long, sizeof is greater than 1, KMALLOC_MAX_SIZE is
unsigned long...  So write that check as KMALLOC_MAX_SIZE / sizeof > nr_pages
