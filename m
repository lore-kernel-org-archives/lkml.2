Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0JKOjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:39:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab0JKOjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:39:23 -0400
Message-ID: <4CB32199.1000401@suse.cz>
Date: Mon, 11 Oct 2010 16:39:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Warn on non-executable files	created
 with non 100644 file permissions
References: <1286407891.32241.21.camel@Joe-Laptop> <20101007065438.GB12741@pengutronix.de>
In-Reply-To: <20101007065438.GB12741@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.10.2010 08:54, Wolfram Sang wrote:
> On Wed, Oct 06, 2010 at 04:31:31PM -0700, Joe Perches wrote:
>> +			my $mode = $1;
>> +			my $file = $2;
>> +			if ($mode ne "100644" && !($file =~ /\.(sh|pl|py|awk)$/)) {
>> +				WARN("FILE '$file' should probably use file permission 100644 not $mode\n" . $herecurr);
>> +			}
> 
> What about checking for no filename extension, too, and changing the message to
> something like "use proper file permission or proper extension"?

That would result in too many false positives, I'm afraid. What about
checking for files with a shebang?

Michal
