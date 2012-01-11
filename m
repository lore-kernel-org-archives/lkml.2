Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab2AKUnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:43:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55329 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751097Ab2AKUnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:43:06 -0500
Message-ID: <1326314582.6774.4.camel@joe2Laptop>
Subject: Re: [RFC PATCH] checkpatch: Add warning for asymmetric brace use
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Julian Andres Klode <jak@jak-linux.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jan 2012 12:43:02 -0800
In-Reply-To: <1326311897.3491.6.camel@joe2Laptop>
References: <1324918660-25708-1-git-send-email-jak@jak-linux.org>
	 <1324918660-25708-5-git-send-email-jak@jak-linux.org>
	 <20120110113552.GJ3644@mwanda> <20120110114835.GB6325@jak-linux.org>
	 <20120110121453.GC16258@mwanda> <1326216615.26536.18.camel@joe2Laptop>
	 <1326311897.3491.6.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 11:58 -0800, Joe Perches wrote:
> Here's a possible checkpatch patch.
> It seems to work on the test cases I've tried.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +				if ($seen) {
> +					my $sum_allowed = 0;
> +					foreach (@allowed) {
> +						$sum_allowed += $_;
> +					}
> +					if ($sum_allowed == 0) {
> +						WARN("BRACES",
> +						     "braces {} are not necessary for any arm of this statement\n" . $herectx);
> +					} elsif ($sum_allowed != $allow) {

I ran some more tests against the kernel source.
This works better as:

+					} elsif ($sum_allowed != $allow &&
+						 $seen != $allow) {

> +						WARN("BRACES",
> +						     "braces {} should be used on all arms of this statement\n" . $herectx);
> +					}



