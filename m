Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2K2C2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:28:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34825 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754807Ab2K2C2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:28:22 -0500
Message-ID: <1354156096.29762.14.camel@joe-AO722>
Subject: Re: [PATCH 0/23] media: Replace memcpy with struct assignment
From: Joe Perches <joe@perches.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media <linux-media@vger.kernel.org>
Date: Wed, 28 Nov 2012 18:28:16 -0800
In-Reply-To: <CALF0-+USC6ButEO0pMRPFj8hGtL90wi3FrxL-BkE1oF42qcggg@mail.gmail.com>
References: <CALF0-+XH4AfJUcNHXdMTwXf-=f24Zpe3VOw_1eQ9WBV1-6ZVjQ@mail.gmail.com>
	 <CALF0-+USC6ButEO0pMRPFj8hGtL90wi3FrxL-BkE1oF42qcggg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 16:06 -0300, Ezequiel Garcia wrote:
> On Tue, Oct 23, 2012 at 4:57 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > This is a large patchset that replaces struct memcpy with struct assignment,
> > whenever possible at drivers/media.
[]
> > A simplified version of the semantic match that finds
> > this problem is as follows: (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > identifier struct_name;
> > struct struct_name to;
> > struct struct_name from;
> > expression E;
> > @@
> > -memcpy(&(to), &(from), E);
> > +to = from;
> > // </smpl>
[]
> > Comments, feedback and flames are welcome. Thanks!
[]
> Given we're very near merge window, I'm wondering if you're
> considering picking this series.

I think you should verify that sizeof is any of
sizeof(struct struct_name) or sizeof(*to) or sizeof(*from)
and highlight any entries that aren't.


