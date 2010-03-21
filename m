Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0CUD6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 23:58:24 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34515 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0CUD6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 23:58:23 -0400
Date: Sat, 20 Mar 2010 20:59:23 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Dan Carpenter <error27@gmail.com>
cc: ceph-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ceph-devel] bug report: ceph: && vs ||
In-Reply-To: <20100320123926.GA30085@bicker>
Message-ID: <Pine.LNX.4.64.1003202058140.15445@cobra.newdream.net>
References: <20100320123926.GA30085@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010, Dan Carpenter wrote:
> 
> 
>   1772          /* correct session? */
>   1773          if (!req->r_session && req->r_session != session) {
> 
> 	Is this supposed to || here?  We know "session" is non-NULL at
> 	the point because we already dereferenced it.  If "req->r_session"
> 	is null then the second condition is always true.
> 
> 	Also we dereference "req->r_session" later on without checking.

Yeah, that check is clearly wrong.  A

	if (req->r_session != session) {

is sufficient because the passed session is always non-NULL.  Applied a 
fix.

Thanks-
sage
