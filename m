Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2KMPxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:53:20 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62994 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2KMPxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:53:19 -0500
Date: Tue, 13 Nov 2012 19:53:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-epoll-add-procfs-fdinfo-helper.patch added to -mm tree
Message-ID: <20121113155313.GU6511@moon>
References: <20121113145050.GA13691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113145050.GA13691@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 03:50:50PM +0100, Oleg Nesterov wrote:
> This doesn't look right.
> 
> The problem is, the current locking is broken, ->siglock can not serialize
> ->sigmask changes. Just suppose the the child inherits sigfd from parent
> and they both do sys_signalfd4() at the same time.
> 
> Nothing really bad can happen, that is why nobody bothers to fix this.
> But this patch makes the thing worse, write_seqcount_begin() must be
> serialized correctly.

Thanks a lot, Oleg! I'll update.
