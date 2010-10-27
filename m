Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642Ab0J0KOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:14:01 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:20745 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab0J0KN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:13:59 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+3aIibppu0283ogF9SEP3jxZhh6Z2
X-RZG-CLASS-ID: mo00
Date: Wed, 27 Oct 2010 12:13:51 +0200
From: Olaf Hering <olaf@aepfle.de>
To: pacman@kosh.dhis.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
 bisected to 6dda9d55)
Message-ID: <20101027101351.GA28218@aepfle.de>
References: <1287608215.2198.23.camel@pasglop>
 <20101027085738.1837.qmail@kosh.dhis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101027085738.1837.qmail@kosh.dhis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, pacman@kosh.dhis.org wrote:

> |1. How do I locate all usb nodes in the device tree?
> |
> |2. How do I know if a particular usb node is OHCI?

In the installed system, run 'lspci | grep -i usb', this gives the pci
bus numbers.  Then run 'find /sys -name devspec', and look or the bus
numbers from the lspci output.  Each devspec file contains the firmware
path.  The ohci node may have subdirectories. Run 'words' in each of
them at the firmware prompt. Perhaps there is one to shutdown the
controller?

I just noticed older firmware did not have a node for ohci, newer ones
my have a /pci@80000000/usb@5 node.

Good luck.

Olaf
