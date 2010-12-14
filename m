Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0LNXcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:32:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663Ab0LNXcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:32:54 -0500
MIME-Version: 1.0
In-Reply-To: <1292368360-32216-1-git-send-email-stefani@seibold.net>
References: <1292368360-32216-1-git-send-email-stefani@seibold.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 15:32:28 -0800
Message-ID: <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why do you repeat that

    inode = iget_locked(sb, cramino(cramfs_inode, offset));
    if (inode && (inode->i_state & I_NEW)) {

so many times?

Wouldn't it be nicer to just do it once at the top?

     Linus
