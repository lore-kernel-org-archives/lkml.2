Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2GPVaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:30:14 -0400
Received: from mx1.math.uh.edu ([129.7.128.32]:36650 "EHLO mx1.math.uh.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab2GPVaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:30:11 -0400
X-Greylist: delayed 3002 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2012 17:30:11 EDT
From: "Jason L Tibbitts III" <tibbs@math.uh.edu>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: =?utf-8?Q?R=C3=A9mi?= Denis-Courmont <remi@remlab.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: Commit 6016af "[media] v4l2: use __u32 rather than enums in ioctl() structs" breaks C++ users of V4L2
Date: Mon, 16 Jul 2012 15:40:01 -0500
Message-ID: <ufabojfv3ry.fsf@epithumia.math.uh.edu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into problems compiling the program ZoneMinder on Fedora rawhide
(currently using something around 3.5rc6) which do not appear with 3.4
kernels.  With help this was traced to commit
6016af82eafcb6e086a8f2a2197b46029a843d68, "[media] v4l2: use __u32
rather than enums in ioctl() structs" which changed videodev2.h in a way
which appears to be incompatible with C++.

This results in code such as the following:
        enum v4l2_buf_type type = v4l2_data.fmt.type;
failing to compile with:
  zm_local_camera.cpp:1523:49: error: invalid conversion from '__u32
  {aka unsigned int}' to 'v4l2_buf_type' [-fpermissive]
but only when compiled with the headers from a 3.5 kernel.

I'm very far from a C++ expert.  I talked with some people who do grok
it and the issue comes down to restrictions on assignments of ints to
enums and additionally that enums in C++ don't have defined size.

 - J<
