Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2JJJrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:47:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab2JJJrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:47:41 -0400
Message-ID: <5075442B.80100@redhat.com>
Date: Wed, 10 Oct 2012 11:47:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, andi@firstfloor.org
Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
References: <1349654347-18337-1-git-send-email-kys@microsoft.com> <1349654386-18378-1-git-send-email-kys@microsoft.com> <1349654386-18378-2-git-send-email-kys@microsoft.com> <20121009124449.f54bf8cb.akpm@linux-foundation.org>
In-Reply-To: <20121009124449.f54bf8cb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 09:44 PM, Andrew Morton wrote:
> On Sun,  7 Oct 2012 16:59:46 -0700
> "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> 
>> Add the basic balloon driver.
> 
> hm, how many balloon drivers does one kernel need?
> 
> Although I see that the great majority of this code is hypervisor-specific.

Much like each network driver is NIC specific.

You could think up a framework into which hypervisor specific balloon
drivers plug in, but you'll find that in each driver 85% of the code is
devoted to talking to the hypervisor, 15% is outdated comments, and the
rest is a call to alloc_pages() and a call to free_pages().

-- 
error compiling committee.c: too many arguments to function
