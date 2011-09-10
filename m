Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab1IJP4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 11:56:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35422 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab1IJP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 11:56:41 -0400
Date: Sat, 10 Sep 2011 16:56:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] xip: use i_mutex for xip_file_fault
Message-ID: <20110910155639.GY2203@ZenIV.linux.org.uk>
References: <4E6B82DB.50803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6B82DB.50803@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 05:31:39PM +0200, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> There aren't sufficient sync points for a fs for xip operations. In 
> particular for the mmap case. It can be not sufficient to lock/unlock 
> to do some operation inside get_xip_mem callback. For xip_file_read 
> it's really easy to write a fs specific wrapper, xip_file_write hold 
> i_mutex so no problem. With this patch we can avoid concurrent truncate 
> operation and xip mmap.

Umm...  I really don't like that; what's going to happen if you have a file
mmapped and do write() to that file from address in that mapping?
