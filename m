Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0LGOdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:33:18 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:13195 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0LGOdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:33:17 -0500
Message-ID: <4CFE45A0.8070408@parallels.com>
Date: Tue, 07 Dec 2010 17:33:04 +0300
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Containers <containers@lists.osdl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] user_ns: Improve the user_ns on-the-slab packaging
References: <4CFE40D1.5000309@parallels.com> <20101207142747.GB4674@hallyn.com>
In-Reply-To: <20101207142747.GB4674@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 05:27 PM, Serge E. Hallyn wrote:
> Quoting Pavel Emelyanov (xemul@parallels.com):
>> Currently on 64-bit arch the user_namespace is 2096 and when
>> being kmalloc-ed it resides on a 4k slab wasting 2003 bytes.
>>
>> If we allocate a separate cache for it and reduce the hash size
>> from 128 to 64 chains the packaging becomes *much* better - the
> 
> Hey Pavel,
> 
> I trust you've done some performance tests and found no
> regressions with a few hundred users?

How many hundreds are you interested in? :) 128 users didn't
reveal any regressions.

> -serge
> 
