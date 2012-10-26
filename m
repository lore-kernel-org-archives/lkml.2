Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2JZSq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:46:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33157 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2JZSq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:46:57 -0400
Message-ID: <508ADA8E.9000604@linux.vnet.ibm.com>
Date: Fri, 26 Oct 2012 13:46:38 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] debugfs: add get/set for atomic types
References: <1351266541-17268-1-git-send-email-sjenning@linux.vnet.ibm.com> <20121026161315.GA13134@kroah.com>
In-Reply-To: <20121026161315.GA13134@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102618-9360-0000-0000-00000C1A7D2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 11:13 AM, Greg Kroah-Hartman wrote:
> On Fri, Oct 26, 2012 at 10:49:01AM -0500, Seth Jennings wrote:
>> debugfs currently lacks the ability to create attributes
>> that set/get atomic_t values.
>>
>> This patch adds support for this through a new
>> debugfs_create_atomic_t() function.
> 
> Why would you want to set an atomic variable type from userspace?

In my particular use case, I'm not setting from userspace, only getting.

All the other types are symmetric, being both settable and gettable,
so I was just trying to blend with the other types.

> What in-kernel code needs this?

None, yet.  I am working on code that does.

If you would rather me send this as part of the patchset for that
code, I can.  I just wanted to get this in early if I could since it
is functionality I can see others using.

For an example, see drivers/staging/ramster/zcache-main.c:132 where
both atomic and non-atomic version of stats are being maintained so
that the non-atomic version can be read by debugfs.

Beside not having an in-kernel user yet, does this approach look good
to you?

Seth

