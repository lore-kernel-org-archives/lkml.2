Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1FTQrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:47:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36994 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab1FTQrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:47:37 -0400
Message-ID: <4DFF799C.9000102@linux.vnet.ibm.com>
Date: Mon, 20 Jun 2011 09:47:24 -0700
From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Brian King <brking@linux.vnet.ibm.com>, kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/ipr.c: reorder error handling code to include
 iounmap
References: <1306851409-14963-1-git-send-email-julia@diku.dk> <4DF0EC00.9020603@linux.vnet.ibm.com> <4DF787BC.8050701@linux.vnet.ibm.com> <Pine.LNX.4.64.1106151050430.10106@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1106151050430.10106@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 01:50 AM, Julia Lawall wrote:
> On Tue, 14 Jun 2011, Brian King wrote:
> 
>> On 06/09/2011 10:51 AM, Wayne Boyer wrote:
>>> On 05/31/2011 07:16 AM, Julia Lawall wrote:
>>>> From: Julia Lawall <julia@diku.dk>
>>>>
>>>> The out_msi_disable label should be before cleanup_nomem to additionally
>>>> benefit from the call to iounmap.
>>>
>>> Yes, this is a problem.  I propose the following patch instead.
>>
>> By removing the out_msi_disable label, if you fail initialization later
>> on and goto cleanup_nomem, you will end up leaving MSI enabled when you exit
>> with this patch.
> 
> I agree.
> 
> julia
> 

I also agree.  Please disregard my patch.

-- 
Wayne Boyer
IBM - Beaverton, Oregon
LTC S/W Development
(503) 578-5236, T/L 775-5236
