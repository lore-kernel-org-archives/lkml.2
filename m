Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422739Ab2KNMXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:23:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63845 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673Ab2KNMXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:23:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
Date: Wed, 14 Nov 2012 12:23:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jonas Bonn <jonas.bonn@gmail.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Markos <markos.chandras@imgtec.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <CACM3HyFE-S2NM75qVS2Fhhm8YoP1jH4mS41aZ5B1gW2wo-Q99g@mail.gmail.com> <50A23906.6010900@imgtec.com>
In-Reply-To: <50A23906.6010900@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211141223.05063.arnd@arndb.de>
X-Provags-ID: V02:K0:kicouRLWYY3dBY69CONRJX77hRsq6DM5Mqeyw/4ADmK
 yz+6z4Ozp4/RWRRng5I0lr/FD3yqMdhUr4hegXrILuUaUTvPS6
 n0qHAMNer7tTV0xdFjMPx/y2ZyQK+X1lI3QyflZjABs8iRHFvh
 tkQ4hGHcQUpwueS+84ZIkJY/w9rayHzDef8+XOqFzWze4NlKxJ
 Zm0iVJzxQ/7kw0QVprat095EY+TNciSnIBRAQRYe11fGJdHrMi
 dgyYQy/zQXSj56kfGQJet5e0nOWTxFSA0v/M/tbhWG4wR+nD9U
 zV7OH2+QIrpS2PJd/GDzSrO7wgQdKZd5+DxdE6h2OHq2+DJmE2
 pMNZmCppUWWilyf5/sws=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012, James Hogan wrote:
> Hopefully with several architecture maintainers asking for this it might
> get somewhere, but indeed we're aware of the feedback problem on that list.
> 
> The points that I've considered for defaulting to old syscalls:
> * doesn't change existing behaviour of other architectures, so is simply
> less risk of breaking them.
> * could possibly make uClibc slightly smaller if it doesn't have to add
> extra arguments.

The second argument is not very good when you consider that it means adding
the same wrapper into the kernel rather than into uClibc, where it can
be stripped out when unused (e.g. for static compilation) and doesn't
have to be present in memory since the library is in pageable user space
memory, while the kernel side implementation would always have to
present.

	Arnd
