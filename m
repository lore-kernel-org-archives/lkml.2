Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2FEOLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:11:38 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:57922 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997Ab2FEOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:11:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Dave Jones <davej@redhat.com>
Subject: Re: [bisected] NFS corruption with 3.4
Date: Tue, 5 Jun 2012 16:11:03 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201206051116.17711.linux@rainbow-software.org> <20120605124537.GA24679@redhat.com>
In-Reply-To: <20120605124537.GA24679@redhat.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201206051611.04075.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2012, Dave Jones wrote:
> On Tue, Jun 05, 2012 at 11:16:17AM +0200, Ondrej Zary wrote:
>  > Hello,
>  > I use NFS for deploying HDD images on new machines. My machine has 2nd
>  > network card just for this, running DHCPD, TFTPD and kernel NFS server.
>  > The target machine is set to boot from LAN and boots SystemRescueCD from
>  > my machine with an autorun script that launches Partimage and deploys
>  > the HDD image (400 to 900 MB compressed).
>  >
>  > It worked fine for years, until now. With kernel 3.4, everyting
>  > works only for the first time after boot (and not always). Next time
>  > (next machine), partimage aborts almost immediately as it's probably
>  > unable to decompress the image file. md5sum is different on my machine
>  > vs. on the target (through NFS). Also SystemRescueCD boot aborts with
>  > md5 error sometimes. Everything works fine after rebooting back to 3.3.
>  >
>  > Bisection found this:
>  >
>  > 0fc9d1040313047edf6a39fd4d7c7defdca97c62 is the first bad commit
>  > commit 0fc9d1040313047edf6a39fd4d7c7defdca97c62
>  > Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
>  > Date:   Wed Mar 28 14:42:54 2012 -0700
>  >
>  >     radix-tree: use iterators in find_get_pages* functions
>  >
>  > Reverting this commit in 3.4 fixes the problem.
>
> I meant to come back to this, because I saw this problem too.
>
> is this patch a problem for the client, or the server ?
> I'm assuming the server, because I saw at least a similar sounding
> problem using an OSX client->Linux server.
>
> 	Dave

Yes, this patch breaks Linux NFS server.

-- 
Ondrej Zary
