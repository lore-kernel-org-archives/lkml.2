Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935351Ab2JaKVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:21:40 -0400
Received: from smtp.tele.fi ([192.89.123.25]:58393 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab2JaKVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:21:38 -0400
X-Originating-Ip: [194.89.68.22]
Date: Wed, 31 Oct 2012 12:21:28 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Olaf Hering <olaf@aepfle.de>
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: require at least Xen 3.4 as
 dom0
Message-ID: <20121031102128.GA8912@reaktio.net>
References: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
 <20121030181732.GZ8912@reaktio.net>
 <20121030182859.GA8775@aepfle.de>
 <1351672212.20470.7.camel@hastur.hellion.org.uk>
 <20121031092925.GA22587@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031092925.GA22587@aepfle.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:29:25AM +0100, Olaf Hering wrote:
> On Wed, Oct 31, Ian Campbell wrote:
> 
> > If I understand correctly this requirements comes from the need to
> > support moving the shared info page in order to support kexec?
> > 
> > So could we do something more fine grained and limit only the kexec
> > support (and therefore the movement of the SI into that range) to 3.4+?
> 
> Its not strictly about kexec. The other patch I sent out will place the
> shared info page at 0xFE700000. If that range is not within a
> E820_Reserved area and if the old hvmloader makes allocations within
> that range, that other patch needs to be changed so that the shared info
> page is done either at 0xFE700000 or within RESERVE_BRK (as it is done
> currently).
> 
> Is the source code of that old RHEL available somewhere, did they patch
> hvmloader at all? Providing a E820 map from a guest which was started on
> such old dom0 would be a good start.
> 

http://ftp.redhat.com/pub/redhat/linux/enterprise/5Server/en/os/SRPMS/xen-3.0.3-135.el5_8.5.src.rpm
That's the userland, actual Xen hypervisor is in the kernel src.rpm.

I can provide a dmesg from a guest later today.

-- Pasi

