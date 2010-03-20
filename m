Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab0CTMkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 08:40:07 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33561 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0CTMkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 08:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=nhXF07P9ZBCgWz4b6+TeItMBnVK2ybkFXkDnX4xxa9xyBhmM7kvfVyMbbMlAzd55Oj
         ql0nJ0BnfpRqklZIkEdaLOi4kcsjE6Imk+58b0gKHnu/idYhNMUd/bWTdZH03mfEbkyE
         NOPx4FBj3ucV9N9lV2dvJNo3gIIdt7yupKXuc=
Date: Sat, 20 Mar 2010 15:39:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: bug report: ceph: && vs ||
Message-ID: <20100320123926.GA30085@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Sage Weil <sage@newdream.net>, ceph-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



  1772          /* correct session? */
  1773          if (!req->r_session && req->r_session != session) {

	Is this supposed to || here?  We know "session" is non-NULL at
	the point because we already dereferenced it.  If "req->r_session"
	is null then the second condition is always true.

	Also we dereference "req->r_session" later on without checking.

  1774                  pr_err("mdsc_handle_reply got %llu on session mds%d"
  1775                         " not mds%d\n", tid, session->s_mds,
  1776                         req->r_session ? req->r_session->s_mds : -1);
  1777                  mutex_unlock(&mdsc->mutex);
  1778                  goto out;
  1779          }
  1780

regards,
dan carpenter
