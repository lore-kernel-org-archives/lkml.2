Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1AJOiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:38:55 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:58220 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1AJOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:38:53 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Important for fs devs: rcu-walk merged upstream
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
Date: Mon, 10 Jan 2011 23:38:47 +0900
Message-ID: <22537.1294670327@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> This is a big and complex change by any measure, so
> please don't be afraid to ask for help or clarification. I'd
> also really like to be able to update documentation
> based on questions from fs maintainers (in and out of
> tree) who are trying to follow it and bring their code up to
> speed.

Question about what d_lock protects.
Can we skip d_lock when we access d_inode and d_name during its parent
i_mutex is held?
Should these BUG_ON be placed after d_lock?

void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
{
	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
	BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives this */

	spin_lock(&dentry->d_lock);
	:::


J. R. Okajima
