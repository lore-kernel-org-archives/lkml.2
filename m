Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2BCUYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:24:39 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:43698 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2BCUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id
	:subject:from:reply-to:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; q=dns; s=
	dreamhost.com; b=dT7wNMdEcU0uAN2XkOG9Wv97LAqqCfpUhwJ7o9KlMXz2hnd
	9JiMuqh/+vY4tpAkXGVYXfFgaYv/Hm+OF0xaqmJjixfuhHMeAps8OTN6P+nvZ2EO
	pLosyTfnP/UcymNDuIGJaTfbjnIFHWGFBoCWwoksZOTY7aPuQDk2TKUqZVLM=
Message-ID: <1328300672.21405.90.camel@doink>
Subject: Re: [PATCH RESEND] ceph: avoid panic with mismatched symlink sizes
 in fill_inode()
From: Alex Elder <elder@dreamhost.com>
Reply-To: elder@dreamhost.com
To: Xi Wang <xi.wang@gmail.com>
Cc: Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Feb 2012 14:24:32 -0600
In-Reply-To: <1328280936-2688-1-git-send-email-xi.wang@gmail.com>
References: <1328280936-2688-1-git-send-email-xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 09:55 -0500, Xi Wang wrote:
> Return -EINVAL rather than panic if iinfo->symlink_len and
> inode->i_size do not match.
> 
> Also use kstrndup rather than kmalloc/memcpy.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Looks good, though it might good to at least call
WARN_ON().  What do you think?

I will commit this (either with or without the
WARN_ON()).

Reviewed-by: Alex Elder <elder@dreamhost.com>


