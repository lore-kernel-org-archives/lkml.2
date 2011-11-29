Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1K2Ac4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:32:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48390 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752788Ab1K2Acz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:32:55 -0500
Message-ID: <1322526773.2075.7.camel@Joe-Laptop>
Subject: Re: [PATCH 02/11] checkpatch: check for common memset parameter
 issues against statments
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 16:32:53 -0800
In-Reply-To: <1322494973-29225-3-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
	 <1322494973-29225-3-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 15:42 +0000, Andy Whitcroft wrote:
> Move the memset checks over to work against the statement.  Also add
> checks for 0 and 1 used as lengths.  Generally these indicate badly
> ordered parameters.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -3111,6 +3111,28 @@ sub process {
>  			     "Avoid line continuations in quoted strings\n" . $herecurr);
>  		}
>  
> +# Check for misused memsets
> +		if (defined $stat && $stat =~ /\bmemset\s*\((.*)\)/s) {

Perhaps this is better.
It allows close parenthesis in the memset.
eg:	memset(foo, bar(baz), sizeof(foo));

	if (defined $stat && $stat = /\bmemset\s*$match_balanced_parentheses/s) {


