Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0JQIVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:21:22 -0400
Received: from mail.perches.com ([173.55.12.10]:2987 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0JQIVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:21:20 -0400
Subject: Re: [PATCH] checkpatch: allow single space before labels
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 01:21:18 -0700
Message-ID: <1287303678.20968.37.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 04:05 -0400, Mike Frysinger wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
>  # check for spaces at the beginning of a line.
> -		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
> +		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/ && $rawline !~ /:$/)  {

Perhaps that's not an ideal test.
Maybe "&& $rawline !~ /^\+ \w+:/" is better.

The current test misidentify labels with comments:
drivers/net/tulip/interrupt.c: oom:    /* Executed with RX ints disabled */


