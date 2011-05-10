Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1EJW3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:29:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab1EJW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:29:20 -0400
Date: Tue, 10 May 2011 15:28:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Barnes, Clifton A." <cabarnes@indesign-llc.com>
Cc: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH] w1: Add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC
 support.
Message-Id: <20110510152841.68fabad2.akpm@linux-foundation.org>
In-Reply-To: <A8DC7EA93EFCBD4498E3857AFE65E5F13A3D90EB@IND07.indesign.net>
References: <A8DC7EA93EFCBD4498E3857AFE65E5F13A3D90EB@IND07.indesign.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 19:57:05 +0000
"Barnes, Clifton A." <cabarnes@indesign-llc.com> wrote:

> Add support for the Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC.
> 
> Another patch from Haojian Zhuang for this part was recently submitted,
> but I believe that this implementation is more consistent with other
> fuel gauge drivers since it uses the power supply interface.
> 

hm, you're not a heavy user of scripts/checkpatch.pl, I see:

total: 190 errors, 704 warnings, 1221 lines checked

that must be a record.

>
> ...
>
> +       new_setting = (u8)simple_strtoul(buf, &endp, 10);

This checkpatch warning is more than cosmetic:

WARNING: consider using kstrto* in preference to simple_strtoul

This is because simple_strtoul() will accept input of the form "42foo"
whereas strict_strtoul() (and, more recently, kstrtoul()) will reject
it.  So fixing that sloppiness in the interface would be a userspace
API change, and we don't like those.

Please go through the patch and clean it up a bit?
