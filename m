Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab0KVNkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:40:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39089 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab0KVNkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:40:13 -0500
Date: Mon, 22 Nov 2010 13:40:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 1/5] Backlight: Add backlight type
Message-ID: <20101122134004.GA6870@srcf.ucam.org>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com> <20101119120523.15bc341c.akpm@linux-foundation.org> <20101119202558.GA10898@srcf.ucam.org> <1290421020.1272.16707.camel@rex> <20101122123050.GA5385@srcf.ucam.org> <1290432949.1272.16768.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290432949.1272.16768.camel@rex>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:35:48PM +0000, Richard Purdie wrote:

> Its the reverse situation I worry about. Are there situations where
> there are multiple connectors on the PCI device and the ACPI interface
> just controls one of them but controls for the other connectors may
> exist?

Yes, that's certainly possible and it'd be desirable to fix this up, but 
the same problem also applies to platform interfaces and it's typically 
unfixable there. My userspace implementation looks at the connector type 
to determine the best approach - if it's not LVDS or eDP it ignores the 
firmware and platform interfaces, so you'll fall back to the raw 
interface if it can provide support for your connector (presumably via 
ddcci, although we don't have this implemented yet)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
