Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab0EMJxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:53:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57086 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752915Ab0EMJw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:52:56 -0400
Date: Thu, 13 May 2010 10:59:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Wright <chrisw@sous-sol.org>
Cc: greg@kroah.com, jbarnes@virtuousgeek.org, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: Re: [PATCH 2/2] pci: allow sysfs file owner to read device
 dependent config space
Message-ID: <20100513105911.6469c434@lxorguk.ukuu.org.uk>
In-Reply-To: <20100513012957.GB28034@sequoia.sous-sol.org>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
	<20100513012957.GB28034@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 18:29:57 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
> check to verify privileges before allowing a user to read device
> dependent config space.  This is meant to protect from an unprivileged
> user potentially locking up the box.

Or hacking it. You could argue the correct requirement is to change it to
require CAP_SYS_RAWIO in fact !

> With this patch the sysfs file owner is also considered privileged enough
> to read all of the config space.

Which breaks the main reason the check was there in the first place. To
stop accidents of the form

	find / -exec grep {} "wibble"

blowing up in people's faces.


I agree with the problem - but IMHO the fix is to require opening the file
checks CAP_SYS_something instead: not to hack the read method and make it
even weirder and more un-Linux than it is now.

