Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0GGMyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:54:44 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:51115 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0GGMym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:54:42 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jul 2010 08:54:42 EDT
Date: Wed, 7 Jul 2010 14:47:31 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
	point for pvclock
Message-ID: <20100707124731.GJ15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
	Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100701173218.125822294@clark.site>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Greg KH schrieb am Donnerstag, dem 01. Juli 2010:

> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

2.6.32.16 fails to boot on my KVM domains using qemu-kvm 0.11.1.

Bisecting between 2.6.32.14 which worked and .16 turned up this commit
as the first culprit[0].

The host is still running 2.6.32.14 and has 8 cores on 2 CPUs.  The
single-cpu KVM domain hangs just after printing 'Write protecting the
kernel read-only data: 9492k'[1].   On a successful boot this line would
usually be followed by 'INIT: version 2.86 booting'.

A 2.6.32.16 with this patch reverted boots fine.

If there's any info you need please just ask.

Cheers,
Peter

0.  http://asteria.noreply.org/~weasel/volatile/2010-07-07-x9KxN34l17c/fileztnjyZ
1.  http://asteria.noreply.org/~weasel/volatile/2010-07-07-VTRuAQGOKlY/zoe-2.6.32.16.png
2.  http://asteria.noreply.org/~weasel/volatile/2010-07-07-Fq0PVc1ecsc/config-2.6.32.16-dsa-amd64
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
