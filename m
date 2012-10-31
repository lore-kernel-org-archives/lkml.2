Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243Ab2JaK1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:27:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13071 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab2JaK1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:27:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344211200"; 
   d="scan'208";a="212967125"
Message-ID: <1351679139.25014.10.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: require at least Xen 3.4 as
 dom0
From: Ian Campbell <ian.campbell@citrix.com>
To: Olaf Hering <olaf@aepfle.de>
CC: Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 31 Oct 2012 11:25:39 +0100
In-Reply-To: <20121031092925.GA22587@aepfle.de>
References: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
	 <20121030181732.GZ8912@reaktio.net> <20121030182859.GA8775@aepfle.de>
	 <1351672212.20470.7.camel@hastur.hellion.org.uk>
	 <20121031092925.GA22587@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 09:29 +0000, Olaf Hering wrote:
> On Wed, Oct 31, Ian Campbell wrote:
> 
> > If I understand correctly this requirements comes from the need to
> > support moving the shared info page in order to support kexec?
> > 
> > So could we do something more fine grained and limit only the kexec
> > support (and therefore the movement of the SI into that range) to 3.4+?
> 
> Its not strictly about kexec. The other patch I sent out will place the
> shared info page at 0xFE700000.

Right, but it does this only in order to support kexec, right? Is there
any other reason to relocate the shinfo in this way?

>  If that range is not within a
> E820_Reserved area and if the old hvmloader makes allocations within
> that range, that other patch needs to be changed so that the shared info
> page is done either at 0xFE700000 or within RESERVE_BRK (as it is done
> currently).

Can it not do both, depending on the detected version of Xen? That's
what I was trying to suggest.

> Is the source code of that old RHEL available somewhere, did they patch
> hvmloader at all? Providing a E820 map from a guest which was started on
> such old dom0 would be a good start.

IIRC The .src.rpm's are available on ftp.redhat.com, or you could
probaly find the centos versions.

Ian.


