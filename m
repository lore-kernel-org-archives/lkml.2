Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab1IJAf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:35:57 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:58023 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1IJAf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:35:56 -0400
Message-ID: <4E6AB0EA.9090505@vflare.org>
Date: Fri, 09 Sep 2011 20:35:54 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Noah Watkins <noahwatkins@gmail.com>
Subject: Re: [PATCH 3/5] zram: Make gobal variables use unique names
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org> <1315609264-13632-4-git-send-email-ngupta@vflare.org> <20110909231028.GA24587@kroah.com>
In-Reply-To: <20110909231028.GA24587@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 07:10 PM, Greg KH wrote:

> On Fri, Sep 09, 2011 at 07:01:02PM -0400, Nitin Gupta wrote:
>> Global variables 'num_devices' and 'devices' are too
>> general to be global. This patch switches the name to
>> be "zram_devices".
>>
>> Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> 
> I've already applied this patch, right?
> 


I just checked another (staging-next) tree which is sync'ed more
recently and yes this patch has been applied.  Since git.kernel.org
seems to be down I couldn't see this change on my working tree.

However, that previous change actually also renamed module parameter
name 'num_devices' to 'zram_num_devices' which does not make much sense
since the boot parameter would now be 'zram.zram_num_devices='.  All
that's needed is to rename that global variable to some less generic
name but the boot/command line parameter name should be retained as
'zram.num_devices=' which is what this new patch does.

So, would it possible for you to back-out that original change and apply
this change instead. Or, should I send a new patch series that "fixes"
that previous change?

Nitin
