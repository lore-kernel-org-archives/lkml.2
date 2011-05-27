Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab1E0Cqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:46:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637Ab1E0Cqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:46:46 -0400
Date: Thu, 26 May 2011 22:45:57 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527024556.GA22396@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Dan Rosenberg <drosenberg@vsecurity.com>,
	Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
	kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
	torvalds@linux-foundation.org, adobriyan@gmail.com,
	penberg@kernel.org, Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
	Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <4DDED4ED.7020806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDED4ED.7020806@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 03:32:13PM -0700, H. Peter Anvin wrote:
 > On 05/26/2011 03:18 PM, Rafael J. Wysocki wrote:
 > > 
 > > Well, as far as I can tell, this feature is going to break hibernation on
 > > both x86_32 and x86_64 at the moment, unless you can guarantee that the
 > > randomized kernel location will be the same for both the boot and the target
 > > kernels.
 > > 
 > 
 > Obviously we can't and we don't.  I'm a bit surprised at that
 > constraint... how can that constraint not break things like kernels of
 > slightly different size?

In Fedora at least, we make sure the kernel you thaw from is the same one
you booted by diddling with grub to force the right kernel to be booted.
By default, you won't see a bootmenu, so it'll just dtrt.  You can still
interrupt the boot process, force a boot menu and pick another kernel
of course, and we used to at least have safeguards in place that would
refuse to thaw an image from a different kernel. (This may or may not
be still true since we rewrote the initramfs tools)

	Dave


