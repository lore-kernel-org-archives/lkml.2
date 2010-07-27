Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0G0XK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:10:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919Ab0G0XKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:10:53 -0400
Date: Tue, 27 Jul 2010 16:10:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Check NULL pointer Dereference in mm/filemap.c
Message-Id: <20100727161049.eeac8c7c.akpm@linux-foundation.org>
In-Reply-To: <20100726082542.GA2646@localhost.localdomain>
References: <20100726082542.GA2646@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 16:25:42 +0800
wzt.wzt@gmail.com wrote:

> mapping->a_ops->direct_IO() is not checked, if it's a NULL pointer, 
> that will casue an oops. pagecache_write_begin/end is exported to
> other functions, so they need to check null pointer before use them. 
> 

The patch checks a lot more things than ->directIO!

It would be best to not add this overhead if possible.  Did you
actually observe an oops?  If so, please fully describe it.

