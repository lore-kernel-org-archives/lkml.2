Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0FUV7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:59:07 -0400
Received: from crca.org.au ([74.207.252.120]:57048 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0FUV7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:59:05 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C1FE09B.9040703@crca.org.au>
Date: Tue, 22 Jun 2010 07:58:51 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Slaby <jslaby@suse.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/9] PM / Hibernate: swap,	switch to hibernate_io_handle
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <4C1205DC.1080200@crca.org.au> <4C1F8366.70306@gmail.com>
In-Reply-To: <4C1F8366.70306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri.

On 22/06/10 01:21, Jiri Slaby wrote:
> On 06/11/2010 11:46 AM, Nigel Cunningham wrote:
>> On 02/06/10 18:52, Jiri Slaby wrote:
>>> I addressed the comments I got on the previous RFC. I left the handles
>>> in place, the functions in hibernate_io_ops now works on them. Further
>>> I got rid of the memory barriers and minimized global variables as much
>>> as possible. Comments welcome.
>>
>> I would like to hear the arguments for using these handles. I understand
>> there may have been some previous discussion, but am unable to find it.
>>
>> It seems far more sensible to me to not pass around a handle that
>> virtually nothing actually uses, and instead store and utilise the state
>> in the place where it is actually useful. If we had more than one struct
>> hibernate_io_handle in use at a time, I could understand going this way.
>> As it stands, however...
>
> Hi, it I added that based on this: http://lkml.org/lkml/2010/3/24/458

Okay; thanks.

Looking at Pavel's comment is confusing. The variable you were adding 
isn't "global static" (that's a contradiction in terms anyway). Its 
scope is the file level.

Since the data is only used in this file, your change makes perfect 
sense to me.

Rafael, Pavel: care to discuss this further?

Nigel
