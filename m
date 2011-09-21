Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1IUQBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:01:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1IUQBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:01:36 -0400
Date: Wed, 21 Sep 2011 08:54:44 -0700
From: Greg KH <gregkh@suse.de>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Trivial: devtmpfsd: Setting task
 running/interruptible states
Message-ID: <20110921155444.GA27121@suse.de>
References: <1316619573-9104-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316619573-9104-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 09:09:33PM +0530, Kautuk Consul wrote:
> This trivial patch makes the following changes in devtmpfsd() :

This is not the definition of "trivial" in that you are changing the
logic of the code, not just doing spelling changes.

> - Set the state to TASK_INTERRUPTIBLE using __set_current_state
>   instead of set_current_state as the spin_unlock is an implicit
>   memory barrier.

Why?  What is this hurting with the original code?

> - After return from schedule(), there is no need to set the current
>   state to TASK_RUNNING as the wake_up_process() function call will
>   do this for us.

Are you sure?

Have you tested this patch and everything works properly?

greg k-h
