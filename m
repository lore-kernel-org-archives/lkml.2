Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1HZRgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:36:43 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:36096 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1HZRgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:36:41 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Aug 2011 13:36:41 EDT
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Paris <eparis@parisplace.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <20110826141410.3d639231@lxorguk.ukuu.org.uk>
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
	 <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com>
	 <20110826141410.3d639231@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Fri, 26 Aug 2011 13:36:26 -0400
Message-ID: <1314380186.25778.30.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 14:14 +0100, Alan Cox wrote:
> > good in that it only takes 1 syscall and ours takes 2.  Your interface
> > is bad in that it is ioctl and we are told since birth that we must
> > hate them no matter what (not that read/write is really any
> > different).  It isn't the same method the only other LSM I know about
> > uses.  It can only every return one value (ok, I know ioctl can be
> > made to do anything at all)
> 
> I'm all in favour of the use of brains rather than the cult of ioctl
> hating. You can design bad ioctls and good ones. Also ioctl is pretty
> much unique in being bidirectional, it allows a query/respose action
> without having to worry about whether the respose is the one to your
> query or another parallel query.

The transaction ops achieve that property as well - the response is
stored in an open file private buffer and thus can only correspond to a
request written to that same open file instance.

-- 
Stephen Smalley
National Security Agency

