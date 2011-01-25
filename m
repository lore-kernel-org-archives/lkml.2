Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1AYAcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:32:12 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:37573 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323Ab1AYAcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:32:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAM+oPU1Ld/sX/2dsb2JhbAAMhAbMY5BXgSSDOHQEhHA
X-IronPort-AV: E=Sophos;i="4.60,372,1291611600"; 
   d="scan'208";a="89117025"
Message-ID: <4D3E1A08.5060303@teksavvy.com>
Date: Mon, 24 Jan 2011 19:32:08 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <20110124175456.GA17855@core.coreip.homeip.net>
In-Reply-To: <20110124175456.GA17855@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-24 12:54 PM, Dmitry Torokhov wrote:
> Hi Mark,
> 
> On Sun, Jan 23, 2011 at 12:03:47PM -0500, Mark Lord wrote:
>> As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
>> no longer work.  And if I grab newer/patched versions of those from the latest
>> Ubuntu 10.10, then those newer/patched versions do not work with kernels
>> *before* 2.6.36.
>>
>> At first glance, this looks like a visible regression.
>> Is there a version of input-utils that works with both
>> old and new kernels ?
>>
> 
> The event protocol number was updated to reflect support of large
> scancodes, unfortunately some of the utilities expected exact version
> and refuse to work with updated one.


So is there a danger of memory corruption if running a binary
that doesn't check the version number?

In other words, did the size and/or format of returned data
change for an ioctl() or something here?

If so, then that is a user-visible regression, and shouldn't happen.
One correct way to handle that, would be to create a new ioctl(),
and mark the old one as deprecated, for removal a few years later perhaps.

???

Thanks
