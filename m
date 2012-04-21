Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2DUWJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:09:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39108 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2DUWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:09:12 -0400
Date: Sat, 21 Apr 2012 23:09:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasikanth V <sasikanth.v19@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: uselib - Set error on do_filp_open failure only
Message-ID: <20120421220911.GT6871@ZenIV.linux.org.uk>
References: <1335044983-2908-1-git-send-email-sasikanth.v19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335044983-2908-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 03:19:43AM +0530, Sasikanth V wrote:
> At present "error" is set irrespective of do_filp_open failed or not.
> Setting error to PTR_ERR(file) on do_filp_open failure only.

NAK, since it's completely pointless.  PTR_ERR() is safe to use on *any*
pointers; result won't be anything interesting unless IS_ERR() is true,
but PTR_ERR() itself can be evaluated just fine.
