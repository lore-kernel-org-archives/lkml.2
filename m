Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768088Ab2KOOoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:44:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45877 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993283Ab2KOOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:44:10 -0500
Date: Thu, 15 Nov 2012 06:44:04 -0800
From: Tejun Heo <tj@kernel.org>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cuse: do not register multiple devices with the same
 name
Message-ID: <20121115144404.GA7306@mtj.dyndns.org>
References: <1352982197-7447-1-git-send-email-dh.herrmann@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352982197-7447-1-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 01:23:17PM +0100, David Herrmann wrote:
> We do not check whether we already registered a CUSE device with a given
> name so we might end up with two devices with the same name. Sysfs will
> then complain as it cannot create suitable directories.
> 
> This patch makes the init-command fail if there is already a device with
> the given name. To avoid race-conditions, we protect the whole
> registration with a mutex now.
> 
> Following the sysfs warnings when registering two devices with the same
> name:
...
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>

Acked-by: Tejun Heo <tj@kernel.org>

But it probably would be better to separate out mutex conversion as a
separate patch.

Thanks!

-- 
tejun
