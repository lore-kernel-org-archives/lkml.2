Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab2ILMwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:52:18 -0400
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:34853 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863Ab2ILMwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:52:17 -0400
Message-ID: <5050857F.5060207@akamai.com>
Date: Wed, 12 Sep 2012 07:52:15 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <1347403947-20187-1-git-send-email-johunt@akamai.com> <504FC2E9.4010708@akamai.com> <20120912085140.GA12277@aftab.osrc.amd.com> <5050824B.9050006@akamai.com>
In-Reply-To: <5050824B.9050006@akamai.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 07:38 AM, Josh Hunt wrote:
> On 09/12/2012 03:51 AM, Borislav Petkov wrote:
>> On Tue, Sep 11, 2012 at 06:02:01PM -0500, Josh Hunt wrote:
>>> On 09/11/2012 05:52 PM, Josh Hunt wrote:
>>>> With recent kernels we noticed that edac was reporting double the memory size on
>>>> systems running with AMD family 0Fh processors. I'm not very familiar with the
>>>> code, but this resolves it from what I can see on my systems. At least in
>>>> amd64_debug_display_dimm_sizes() and k8_dbam_to_chip_select() there appeared
>>>> to be redundant shifts to the left by 1 when WIDTH_128 is present.
>>
>> Any chance you could enable CONFIG_EDAC_DEBUG, boot and send me your
>> whole dmesg? Privately is fine too.
>>
>> Thanks.
>>
> 
> Sure. Attached. This is booting with latest git.
> 
> Josh

I wanted to add that we started seeing this back in 3.0. I didn't go
back any farther, but know it was not occurring in 2.6.38. The issue in
3.0 appeared to be that we shift left k8_dbam_to_chip_select() and there
was also another shift in amd64_csrow_nr_pages(). It looks like that
second shift has been replaced by a more recent patch, which actually
checks to see if the csrow is enabled and then counts nr_pages again
adding that to the first calculation, still resulting in the size being
double.

Josh
