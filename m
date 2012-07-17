Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2GQEuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:50:08 -0400
Received: from oyp.chewa.net ([91.121.6.101]:58294 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2GQEuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:50:06 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 00:50:06 EDT
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: "Jason L Tibbitts III" <tibbs@math.uh.edu>
Subject: Re: Commit 6016af "[media] v4l2: use __u32 rather than enums in ioctl() structs" breaks C++ users of V4L2
Date: Tue, 17 Jul 2012 07:39:35 +0300
User-Agent: KMail/1.13.7 (Linux/3.4.4-basile; KDE/4.8.4; i686; ; )
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
References: <ufabojfv3ry.fsf@epithumia.math.uh.edu>
In-Reply-To: <ufabojfv3ry.fsf@epithumia.math.uh.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207170739.37176.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 juillet 2012 23:40:01 Jason L Tibbitts III, vous avez écrit :
> I ran into problems compiling the program ZoneMinder on Fedora rawhide
> (currently using something around 3.5rc6) which do not appear with 3.4
> kernels.  With help this was traced to commit
> 6016af82eafcb6e086a8f2a2197b46029a843d68, "[media] v4l2: use __u32
> rather than enums in ioctl() structs" which changed videodev2.h in a way
> which appears to be incompatible with C++.
> 
> This results in code such as the following:
>         enum v4l2_buf_type type = v4l2_data.fmt.type;

That code is dangerous, probably even more so in C++. If the running kernel 
version is more recent than the kernel header version that userland was 
compiled with, the field value could be outside the range of the enumeration.

> failing to compile with:
>   zm_local_camera.cpp:1523:49: error: invalid conversion from '__u32
>   {aka unsigned int}' to 'v4l2_buf_type' [-fpermissive]
> but only when compiled with the headers from a 3.5 kernel.
> 
> I'm very far from a C++ expert.  I talked with some people who do grok
> it and the issue comes down to restrictions on assignments of ints to
> enums


> and additionally that enums in C++ don't have defined size.

That cannot be true. Your C++ compiler must agree with the kernel's C compiler 
on the size of enum. If they did not, V4L2 would not have ever worked from C++ 
code in previous kernel versions.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
