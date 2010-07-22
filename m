Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0GVMVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:21:09 -0400
Received: from daytona.panasas.com ([67.152.220.89]:38414 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761Ab0GVMVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:21:04 -0400
Message-ID: <4C4837A5.6040209@panasas.com>
Date: Thu, 22 Jul 2010 15:20:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: bitwise operations might not fit in a "bool"
References: <4C47ED7B.1050709@gmail.com>	<20100722173716.66264bef@notabene>	<4C481FD5.4070509@gmail.com>	<4C482F35.6000004@panasas.com> <20100722215555.7ab2b1ee@notabene>
In-Reply-To: <20100722215555.7ab2b1ee@notabene>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2010 12:21:03.0976 (UTC) FILETIME=[5A77CE80:01CB2998]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 02:55 PM, Neil Brown wrote:
> On Thu, 22 Jul 2010 14:44:53 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>
>> when taking a resolute of a bit-wise AND as true false. Better / faster
>> to make it a boolean operation.
>>
>> This fixes a bug and a crash because the flags field did not fit into
>> the bool operands.
> 
> No, that won't work.
> Read the rest of the code and see where 'do_sync' and 'do_barriers' are used.
> 
> NeilBrown
> 

You are right! (I didn't look)

the use of "bool" was wrong from the get go. it was never a bool operation.
What was the guy thinking? What is that do_XXX name? that name should change
as well. Perhaps flg_sync, flg_barriers.

Boaz
