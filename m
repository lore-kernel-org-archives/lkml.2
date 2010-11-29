Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0K2Kcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:32:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0K2Kcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:32:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tDl9oXaBDbZRlBFMn5not+lQ2d1MZCBila0C3L5ffRJr0romk1ZYRKUn3AWmzfMxzz
         6Duak6IdGzuVgD72UertDJfFeg/r5unVx+c30l9VUKoaS0blClRcIk/gkvqZaE24MB3P
         li6K9Dk4QslzvmM2YfJeirdhT4GfP7tE6YPwA=
MIME-Version: 1.0
Date: Mon, 29 Nov 2010 15:32:38 +0500
Message-ID: <AANLkTi=NU5mDQoRMM7n-F78c_pk+nmOd3=4J8L9puZAd@mail.gmail.com>
Subject: Splice: splice_direct_to_actor() and randomly data drop
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
	<socketpair@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing implementation of  splice_direct_to_actor(), I decide, that
"random data drop" can appear if we alrady have done splice_to, but
have problems with splice_from.

1. Why not to use tee() instead of splice_to ? and after all
operations copmleted successfully, just consume data from IN to
/dev/null :) anyhow.

It will allow to splice between ANY file descriptors, not between
"regular file/block device" and ANY.

2. After that, in do_splice we might call do_splice_direct() if both
file descriptors are not pipe.

-- 
Segmentation fault
