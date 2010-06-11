Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0FKU1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:27:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab0FKU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:27:04 -0400
Date: Fri, 11 Jun 2010 13:26:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, yi.y.yang@intel.com,
       Jiri Kosina <trivial@kernel.org>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 1/2] kstrto*: converting strings to integers done
 (hopefully) right
Message-Id: <20100611132638.976869e8.akpm@linux-foundation.org>
In-Reply-To: <20100609214616.GA31340@x200>
References: <20100609214616.GA31340@x200>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 00:46:17 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> 1. simple_strto*() suck because they do not contain overflow checks
>    and crufty, libc way to indicate failure.
> 2. strict_strto*() also do not have overflow checks but the name
>    and comments pretend they do.
> 3. Both have only "long long" and "long" versions, but users want
>    e. g. strtouint()
> 4. Both "simple" and "strict" prefixes are wrong:
>    Simple doesn't say what's so simple, strict should not exist because
>    conversion should be strict by default.
> 
>    The solution is to use "k" prefix and add convertors for more types.
> 
>    Enter
> 
>    	kstrtoull(),
> 	kstrtoll(),
> 	kstrtoul(),
> 	kstrtol(),
> 	kstrtouint(),
> 	kstrtoint(),
> 	kstrtou64(),
> 	kstrtos64(),
> 	kstrtou32(),
> 	kstrtos32(),
> 	kstrtou16(),
> 	kstrtos16(),
> 	kstrtou8(),
> 	kstrtos8()

aw man, you're killin me.  That means 100000 stupid "convert to kstro*"
patches and 10000 "please use kstrto*" comments from patch reviewers. 
Or at least, one patch reviewer :(

For new code I'd like to see a checkpatch "hey dummy you used the old
API" rule, please.  For old code I think I'd punt any cleanup patches
in a Jiriwards direction, OK?

But right now I'm wondering if the problems you've identified are big
enough to bother fixing.

