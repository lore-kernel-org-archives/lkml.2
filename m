Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1EBVnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:43:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50415 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1EBVni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=btAVKU+Nt+l06xkfXQ3E0a1nBggXMBQddDxmvylFrrimTAwk0dPw84vnX3/d3fK+5N
         1bwHCjaQWZc+xHOh89yI40JgGAsYc/z2g8t/wsi4/VkXDY8DMQEeqhqHtxLOS7ZEOzs+
         QNg2qOb1mQUn74nubNPtK/QVCXlLSPlVBqPSo=
MIME-Version: 1.0
In-Reply-To: <m1aaf5vsbk.fsf@fess.ebiederm.org>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
 <m1zkn68mpk.fsf@fess.ebiederm.org> <BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
 <m1r58i2g02.fsf@fess.ebiederm.org> <BANLkTinTMckhNYx1OiyH_YR+hr31naPQHw@mail.gmail.com>
 <m1aaf5yf64.fsf@fess.ebiederm.org> <BANLkTi=PazFJ2QAXArCK52X7JM-xq5Ca5w@mail.gmail.com>
 <m1aaf5vsbk.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 2 May 2011 23:43:17 +0200
Message-ID: <BANLkTikfueeOr2D7TO5uyG=L3A-dbEsUyw@mail.gmail.com>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 9:02 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Do you also have a lot of network namespaces in the workloads you care
> about?

No, the usecase deals with high number of netdevices.

The cookie can be used in lots of places that kmemdup ctl_table arrays
and then set ->data to be the address of a member of a structure.
- netdevice config sysctls
- netns specific sysctls (e.g. net/somaxconn
- parport device specific sysctls
- cpu sched domain config sysctls
- et. al.

I sent another series sometime in February that added the cookie to
ipv4/6 conf sysctls.
I don't know why I did not include that in the patch series from April.

> The cookie changes seem particularly intrusive, and if I read your
> patches properly the cookies are only useful for table sharing when
> implementing network namespaces.  At first glance those changes seem
> pretty horrible.


I know it's ugly. I was thinking about this today. I think I have a
cleaner solution, that I'll post after this patch series.

-- 
 .
..: Lucian
