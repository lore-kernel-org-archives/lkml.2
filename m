Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118Ab0EUTdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0EUTdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:33:23 -0400
Date: Fri, 21 May 2010 20:32:51 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>, dm-devel@redhat.com
Subject: Re: [dm-devel] add devname module aliases to allow module
	on-demand auto-loading
Message-ID: <20100521193251.GP3991@agk-dp.fab.redhat.com>
Mail-Followup-To: Kay Sievers <kay.sievers@vrfy.org>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <chris.mason@oracle.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Ian Kent <raven@themaw.net>, dm-devel@redhat.com
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> <201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com> <20100521182325.GO3991@agk-dp.fab.redhat.com> <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 08:51:49PM +0200, Kay Sievers wrote:
> The kernel itself creates /dev/mapper/control today. 

Must have missed that patch:)
Userspace lvm and dm code is certainly not tied to that today.

The device node that userspace lvm and dm tools use is under the
complete control of this userspace code: it chooses the name, and
creates or fixes it if it doesn't already exist with the required
properties: anything devtmpfs is relevant only if it guessed the
right name that this *completely independent* userspace code
chooses to use and already created it exactly as required.

If we were to move to a fixed name for the control device and hand
control of that name to the kernel, then obviously this userspace
code would need adjusting to respect that.

Alasdair

