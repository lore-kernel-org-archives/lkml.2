Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab1GKXDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:03:45 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33555 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758327Ab1GKXDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:03:43 -0400
Message-ID: <4E1B80ED.8010009@metafoo.de>
Date: Tue, 12 Jul 2011 01:02:05 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
 framework
References: <20110711135056.GT29245@infomag.iguana.be> <1310392522-9949-1-git-send-email-wim@iguana.be> <20110711213224.GC5811@pengutronix.de>
In-Reply-To: <20110711213224.GC5811@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 11:32 PM, Wolfram Sang wrote:

>> +int watchdog_register_device(struct watchdog_device *wdd)
>> +{
>> +	int ret;
>> +
>> +	/* Make sure we have a valid watchdog_device structure */
>> +	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
>> +		return -EINVAL;
>> +
>> +	/* Make sure that the mandatory operations are supported */
>> +	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
>> +		return -EINVAL;
> 
> Check also for wdd->ops->owner? Should we mark it as mandatory?
> 

If the driver is built-in owner will be NULL.

