Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab2DWUib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:38:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56231 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2DWUi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:38:28 -0400
Date: Mon, 23 Apr 2012 13:38:24 -0700
From: greg <gregkh@linuxfoundation.org>
To: yan <clouds.yan@gmail.com>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Subject: Re: [PATCH 1/4][Trivial] lib/kobject.c: Check parameter in
 kobject_get_path
Message-ID: <20120423203824.GA13075@kroah.com>
References: <1335000350.2188.5.camel@yan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335000350.2188.5.camel@yan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 05:25:42PM +0800, yan wrote:
> kobject_get_path is exported, it passes its parameter kobj to
> get_kobj_path_length and fill_kobj_path which are both static 
> and called only once here. So check this parameter.

Why?  If you call this function, you should pass in a valid pointer,
that's the proper way to call it.  No need to be "defensive" here at
all, if the caller messes up, then it crashes, as it should not be
making this type of call on a NULL pointer.

In looking at all of the in-kernel users of this function, they all do
this properly, so I see no need for this patch.

And these types of patches are not "trivial" at all, so please don't
mark them as such.

thanks,

greg k-h
