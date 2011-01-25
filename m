Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1AYA0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:26:07 -0500
Received: from v020138.sys.capside.net ([81.25.117.138]:32891 "EHLO
	n023010.sys.capside.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1AYA0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:26:04 -0500
Date: Tue, 25 Jan 2011 01:25:55 +0100
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Mickler <florian@mickler.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] get_maintainer.pl: Add support to match arbitrary text
Message-ID: <20110125002555.GB13167@bart.evergreen.loc>
References: <1295911951-12615-1-git-send-email-agimenez@sysvalve.es>
 <1295913226.3101.60.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295913226.3101.60.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 03:53:46PM -0800, Joe Perches wrote:
> On Tue, 2011-01-25 at 00:32 +0100, L. Alberto Giménez wrote:
> > Extend the usage of the K section in the MAINTAINERS file to support matching
> > regular expressions with the content that precedes the patch (delimited by three
> > dashes "---").
> > +		} elsif (not $in_patch and m/^---/) {
> > +			# enter "patch area": keywords matched only on changed lines
> > +			$in_patch = 1;
> 
> Not all patches need or have ---
> 
> This would be better as "^---$"

Hi Joe,

As I replied to you previously, please feel free to fix the patch. Most of the
patches I've seen use that line as a separator. Could you please give me the
right regexp to detect the beginning of patches?

On the other hand, if it's not properly detected, it will just match the "K"
keywords against all the patch lines (not just deleted or added lines). For a
standard unified diff format that would be 3 context lines that should match
with something like "^Subject: whatever". Again, it's just a proposal waiting
for comments/enhancements.

The idea here was to enable "triggers" in the subject to add the proper CCs. It
just ended up in a "match anything against the file content" change.

Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
