Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2DWUlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:41:24 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48186 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2DWUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:41:23 -0400
Date: Mon, 23 Apr 2012 13:41:18 -0700
From: greg <gregkh@linuxfoundation.org>
To: yan <clouds.yan@gmail.com>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Subject: Re: [PATCH 4/4][Trivial] lib/kobject.c : check parameter in
 kobject_init_and_add
Message-ID: <20120423204118.GD13075@kroah.com>
References: <1335003475.2188.43.camel@yan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335003475.2188.43.camel@yan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 06:17:49PM +0800, yan wrote:
> If user turns to the simple interface kobject_init_and_add 
> and gives a null kobject, kobject_init can detect it but 
> just dumps the stack. Then there is:
>   -->kobject_add_varg
>    -->kobject_set_name_vargs
> In the end, it will reference kobj->name and we have an oops.
> 
> Check whether we have a valid kobject in kobject_init_and_add.

Why would anyone ever call this function without a valid kobject?

Again, sorry, this patch isn't ok.

greg k-h
