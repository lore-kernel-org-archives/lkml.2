Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2GXSf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:35:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab2GXSf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:35:56 -0400
Message-ID: <1343155010.29196.1.camel@dcbw.foobar.com>
Subject: Re: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
From: Dan Williams <dcbw@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Olaf Hering <olaf@aepfle.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        apw@canonical.com, netdev@vger.kernel.org, ben@decadent.org.uk
Date: Tue, 24 Jul 2012 13:36:50 -0500
In-Reply-To: <20120724095659.5c869511@nehalam.linuxnetplumber.net>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-10-git-send-email-kys@microsoft.com>
	 <20120724092914.60f3d90a@nehalam.linuxnetplumber.net>
	 <20120724165359.GA8409@aepfle.de>
	 <20120724095659.5c869511@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 09:56 -0700, Stephen Hemminger wrote:
> On Tue, 24 Jul 2012 18:53:59 +0200
> Olaf Hering <olaf@aepfle.de> wrote:
> 
> > On Tue, Jul 24, Stephen Hemminger wrote:
> > 
> > > On Tue, 24 Jul 2012 09:01:34 -0700
> > > "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > > 
> > > > +	memset(cmd, 0, sizeof(cmd));
> > > > +	strcat(cmd, "/sbin/ip -f inet  route | grep -w ");
> > > > +	strcat(cmd, if_name);
> > > > +	strcat(cmd, " | awk '/default/ {print $3 }'");
> > > 
> > > 
> > > Much simpler method:
> > > 
> > > ip route show match 0/0
> > 
> > This also has the benefit that ip is not called with absolute path, now
> > that distros move binaries around.
> > 
> > Olaf
> 
> It is also not hard to do the same thing with a little function
> using libmnl

Yeah seriously, netlink anyone?  You'll even get nicer error reporting
that way.

Dan

