Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2FENqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:46:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:54376 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab2FENqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:46:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: [bisected] NFS corruption with 3.4
Date: Tue, 05 Jun 2012 15:45:46 +0200
Organization: The Fists of the White Lotus
Message-ID: <pan.2012.06.05.13.45.45.857750@googlemail.com>
References: <201206051116.17711.linux@rainbow-software.org> <20120605124537.GA24679@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p5086a13f.dip.t-dialin.net
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2012 08:45:37 -0400, Dave Jones wrote:

>  > It worked fine for years, until now. With kernel 3.4, everyting works
>  > only for the first time after boot (and not always). Next time (next
>  > machine), partimage aborts almost immediately as it's probably unable
>  > to decompress the image file. md5sum is different on my machine vs. on
>  > the target (through NFS). Also SystemRescueCD boot aborts with md5
>  > error sometimes. Everything works fine after rebooting back to 3.3.
>  > 
>  > Bisection found this:
>  > 
>  > 0fc9d1040313047edf6a39fd4d7c7defdca97c62 is the first bad commit commit
>  > 0fc9d1040313047edf6a39fd4d7c7defdca97c62 Author: Konstantin Khlebnikov
>  > <khlebnikov@openvz.org> Date:   Wed Mar 28 14:42:54 2012 -0700
>  > 
>  >     radix-tree: use iterators in find_get_pages* functions
>  > 
>  > Reverting this commit in 3.4 fixes the problem.
> 
> I meant to come back to this, because I saw this problem too.

Same here, seen just yesterday.

> is this patch a problem for the client, or the server ? I'm assuming the

In my case I tried to unpack a remote kernel tarball locally to a client
and suddenly got gzip/tar checksum/EOF errors, which repeatably didn't
show up when unpacking said archive directly on the server. Somewhat
confused I re-created a fresh tarball, which then unpacked fine on the
client. Looks like this is a pagecache race/staleness issue.

-h


