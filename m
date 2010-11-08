Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0KHIBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:01:49 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:54100 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab0KHIBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:01:48 -0500
To: <jesse.brandeburg@intel.com>
Cc: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured by reboot)
References: <87ocaaszx1.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A136602815A3C7@rrsmsx501.amr.corp.intel.com>
	<87zktsskua.fsf@spindle.srvr.nix>
	<1288837586.2835.3.camel@jbrandeb-mobl2>
From: Nix <nix@esperi.org.uk>
Emacs: impress your (remaining) friends and neighbors.
Date: Mon, 08 Nov 2010 08:01:29 +0000
In-Reply-To: <1288837586.2835.3.camel@jbrandeb-mobl2> (Jesse Brandeburg's message of "Wed, 03 Nov 2010 22:26:26 -0400")
Message-ID: <87wrooi6qu.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Nov 2010, Jesse Brandeburg spake thusly:
> The above could be responsible for your issue.  If you don't want to
> disable ASPM system wide, then you could just make sure to run a recent
> kernel with the ASPM patches, or get our e1000.sf.net e1000e driver and
> try it, as it will work around the issue whether or not aspm is enabled.

For the record, cherry-picking ff10e13cd06f3dbe90e9fffc3c2dd2057a116e4b
(the periodic phy-crash-and-reset check) atop 2.6.36 seems to have fixed
it: at least, the machine has been up for a day now without trouble.
This commit doesn't seem to be in Greg's stable-queue yet, but seems
like a good candidate.

It's still rather gruesome that anything like this is even needed, but
as long as it only fires every hour or so I guess I can live with it.
Are there firmware updates or something that might fix this properly in
the end?
