Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2HFOH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:07:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48100 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2HFOHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:07:55 -0400
MIME-Version: 1.0
Message-ID: <f54214e7-cee4-4cbf-aad1-6c1f91867879@default>
Date: Mon, 6 Aug 2012 07:07:23 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: RE: [RFC/PATCH] zcache/ramster rewrite and promotion
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
 <CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
 <b9bee363-321e-409a-bc8e-65ffed8a1dc5@default>
 <CAOJsxLHe6egmMWdEAGj7DGHHX-hqYMhVWDggny9CsT0H-DOL-g@mail.gmail.com>
In-Reply-To: <CAOJsxLHe6egmMWdEAGj7DGHHX-hqYMhVWDggny9CsT0H-DOL-g@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> Subject: Re: [RFC/PATCH] zcache/ramster rewrite and promotion
> 
> Hi Dan,
> 
> On Wed, Aug 1, 2012 at 12:13 AM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > Ramster does the same thing but manages it peer-to-peer across
> > multiple systems using kernel sockets.  One could argue that
> > the dependency on sockets makes it more of a driver than "mm"
> > but ramster is "memory management" too, just a bit more exotic.
> 
> How do you configure it?

Hi Pekka --

It looks like the build/configuration how-to at
https://oss.oracle.com/projects/tmem/dist/files/RAMster/HOWTO-v5-120214 
is out-of-date and I need to fix some things in it.  I'll post
a link to it after I update it.

> Can we move parts of the network protocol under
> net/ramster or something?

Ramster is built on top of kernel sockets.  Both that networking
part and the configuration part of the ramster code are heavily
leveraged from ocfs2 and I suspect there is a lot of similarity
to gfs code as well.  In the code for both of those filesystems
I think the network and configuration code lives in the same
directory with the file system, so that was the model I was following.

I'm OK with placing it wherever kernel developers want to put
it, as long as the reason is not NIMBY-ness. [1]  My preference
is to keep all the parts together, at least for the review phase,
but if there is a consensus that it belongs someplace else,
I will be happy to move it.

Dan

[1] http://en.wikipedia.org/wiki/NIMBY
