Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1IVKIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:08:38 -0400
Received: from maxipes.logix.cz ([93.89.80.122]:54782 "EHLO maxipes.logix.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1IVKIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:08:36 -0400
X-Greylist: delayed 1039 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Sep 2011 06:08:35 EDT
Message-ID: <4E7B04F8.3090500@logix.net.nz>
Date: Thu, 22 Sep 2011 21:50:48 +1200
From: Michal Ludvig <mludvig@logix.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, weiyang@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com
Subject: Re: [PATCH] Resource: wrong resource window calculation
References: <4E5E0A7E.40301@logix.net.nz> <CAErSpo70k6UnhvvOMgQQxJ6BHZOwym=-jaPMvOukAaCr-B0+cQ@mail.gmail.com> <4E5EFFBD.4050201@logix.net.nz> <CAErSpo6bofeiAxeRo_RjXQSnwmcWrdymn0MK8H4_CwqwoeD1jg@mail.gmail.com> <4E634814.4050508@logix.net.nz> <20110909113409.GE2416@ram-ThinkPad-T61> <4E6C05B7.9000904@logix.net.nz> <20110913110646.GB2425@ram-ThinkPad-T61> <4E6F400A.6090909@logix.net.nz> <20110922074858.GG5085@ram-ThinkPad-T61>
In-Reply-To: <20110922074858.GG5085@ram-ThinkPad-T61>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 07:48 PM, Ram Pai wrote:
>    	Resource: wrong resource window calculation
>
> __find_resource() incorrectly returns a resource window which overlaps an
> existing allocated window. This happens when the parent's resource-window spans
> 0x00000000 to 0xffffffff and is entirely allocated to all its children
> resource-windows.
>
> __find_resource() looks for gaps in resource allocation among the children
> resource windows.  When it encounters the last child window it blindly tries
> the range next to one allocated to the last child. Since the last child's
> window ends at 0xffffffff the calculation overflows, leading the algorithm to
> believe that any window in the range 0x0000000 to 0xfffffff is available for
> allocation. This leads to a conflicting window allocation.
>
> Michal Ludvig reported this issue seen on his platform. The following patch
> fixes the problem and has been verified by Michal. I believe this bug has been
> there for ages. It got exposed by git commit
> 2bbc6942273b5b3097bd265d82227bdd84b351b2
> [PATCH] PCI : ability to relocate assigned pci-resources
>
> Signed-off-by: Ram Pai<linuxram@us.ibm.com>

Tested-by: Michal Ludvig <mludvig@logix.net.nz>

Works fine on top of 3.1.0-rc7 and solves the problem with my Jetway board.

Thanks Ram!

M.
