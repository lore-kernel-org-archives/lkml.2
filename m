Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2FEMqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:46:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab2FEMqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:46:10 -0400
Date: Tue, 5 Jun 2012 08:45:37 -0400
From: Dave Jones <davej@redhat.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] NFS corruption with 3.4
Message-ID: <20120605124537.GA24679@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	Hugh Dickins <hughd@google.com>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <201206051116.17711.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206051116.17711.linux@rainbow-software.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 11:16:17AM +0200, Ondrej Zary wrote:
 > Hello,
 > I use NFS for deploying HDD images on new machines. My machine has 2nd network 
 > card just for this, running DHCPD, TFTPD and kernel NFS server. The target 
 > machine is set to boot from LAN and boots SystemRescueCD from my machine with 
 > an autorun script that launches Partimage and deploys the HDD image (400 to 
 > 900 MB compressed).
 > 
 > It worked fine for years, until now. With kernel 3.4, everyting 
 > works only for the first time after boot (and not always). Next time (next 
 > machine), partimage aborts almost immediately as it's probably unable to 
 > decompress the image file. md5sum is different on my machine vs. on the 
 > target (through NFS). Also SystemRescueCD boot aborts with md5 error 
 > sometimes. Everything works fine after rebooting back to 3.3.
 > 
 > Bisection found this:
 > 
 > 0fc9d1040313047edf6a39fd4d7c7defdca97c62 is the first bad commit
 > commit 0fc9d1040313047edf6a39fd4d7c7defdca97c62
 > Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
 > Date:   Wed Mar 28 14:42:54 2012 -0700
 > 
 >     radix-tree: use iterators in find_get_pages* functions
 > 
 > Reverting this commit in 3.4 fixes the problem.

I meant to come back to this, because I saw this problem too.

is this patch a problem for the client, or the server ?
I'm assuming the server, because I saw at least a similar sounding
problem using an OSX client->Linux server.

	Dave

