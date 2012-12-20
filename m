Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2LTR1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:27:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53661 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LTR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:26:57 -0500
Message-ID: <50D34A5D.8060404@wwwdotorg.org>
Date: Thu, 20 Dec 2012 10:26:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usb: phy: using kzalloc instead of kmalloc
References: <1355991951-3503-1-git-send-email-vbyravarasu@nvidia.com> <50D3082C.7070008@mvista.com>
In-Reply-To: <50D3082C.7070008@mvista.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 05:44 AM, Sergei Shtylyov wrote:
> Hello.
> 
> On 20-12-2012 12:25, Venu Byravarasu wrote:
> 
>> As Tegra PHY driver open is using kmalloc,
>> changing it to kzalloc.

Indeed, better might be:

usb: phy: use kzalloc to allocate struct tegra_usb_phy

Use kzalloc instead of kmalloc to allocate struct tegra_usb_phy. This
ensures that all function pointers in member u_phy are initialized to
NULL, and hence bogus functions won't be called.
