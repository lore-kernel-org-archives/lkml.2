Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1CNE43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 00:56:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57225 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1CNE42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 00:56:28 -0400
Message-ID: <4D7D9F92.5010604@kernel.org>
Date: Sun, 13 Mar 2011 21:54:42 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com> <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 05:43 PM, Mike Waychison wrote:
> This patch introduces the 'memconsole' driver.
> 
> Our firmware gives us access to an in-memory log of the firmware's
> output.   This gives us visibility in a data-center of headless machines
> as to what the firmware is doing.
> 
> The memory console is found by the driver by finding a header block in
> the EBDA.  The buffer is then copied out, and is exported to userland in
> the file /sys/firmware/log.
> 

OK, I really don't like this.

All it has is a 32-bit nonrandom signature, no DMI keying or anything
else to protect it.  This really isn't sufficient.

	-hpa
