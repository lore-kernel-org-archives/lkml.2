Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2DSMkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:40:18 -0400
Received: from mail1.windriver.com ([147.11.146.13]:39718 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2DSMkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:40:16 -0400
Message-ID: <4F9007A7.9070504@windriver.com>
Date: Thu, 19 Apr 2012 08:40:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile
References: <1334779123-21957-1-git-send-email-paul.gortmaker@windriver.com> <20120419091450.GF16861@axis.com>
In-Reply-To: <20120419091450.GF16861@axis.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-19 05:14 AM, Jesper Nilsson wrote:
> On Wed, Apr 18, 2012 at 09:58:43PM +0200, Paul Gortmaker wrote:
>> Most of these have been purged years ago.  This one silently lived
>> on until commit 69349c2dc01c489eccaa4c472542c08e370c6d7e
>>
>>     "kconfig: fix IS_ENABLED to not require all options to be defined"
>>
>> In the above, we use some macro trickery to create a conditional that
>> is valid in CPP and in C usage.  However that trickery doesn't sit
>> well if you have the legacy "-traditional" flag enabled.  You'll get:
>>
>>   AS      arch/cris/arch-v10/lib/checksum.o
>> In file included from <command-line>:4:0:
>> include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
>> make[2]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1
>>
>> Everything builds fine w/o "-traditional" so simply drop it from this
>> location as well.
>>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Agreed, I'll push this to the CRIS-tree. Thanks!

Thanks, Please make sure it goes on your "for-3.4" branch,
since Linus took the kconfig change directly into 3.4 (i.e. it
is not specific to linux-next).

Paul.

> 
> /^JN - Jesper Nilsson
