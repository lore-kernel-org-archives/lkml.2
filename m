Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1HSIcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 04:32:18 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:48288 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1HSIcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 04:32:14 -0400
Message-ID: <4E4E1F89.4070702@ge.com>
Date: Fri, 19 Aug 2011 09:32:09 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Manohar Vanga <manohar.vanga@cern.ch>, devel@driverdev.osuosl.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: vme: add functions for bridge module	refcounting
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>	<1313145051-13397-4-git-send-email-manohar.vanga@cern.ch> <20110813085454.GA3409@flamenco.cs.columbia.edu>
In-Reply-To: <20110813085454.GA3409@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2011 08:28:41.0002 (UTC) FILETIME=[002690A0:01CC5E4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/11 09:54, Emilio G. Cota wrote:
> On Fri, Aug 12, 2011 at 12:30:49 +0200, Manohar Vanga wrote:
>> This patch adds functions that allow for reference counting
>> bridge modules. The patch introduces the functions
>> 'vme_bridge_get()' and 'vme_bridge_put()'.
> (snip)
>> +int vme_bridge_get(unsigned int bus_id)
> (snip)
>> +void vme_bridge_put(struct vme_bridge *bridge)
> 
> Note the input parameter imbalance; in fact this is serious
> (see my email on patch 5) because _get() needs to acquire
> vme_buses_lock, whereas _put() doesn't. Since a caller with
> bridge has bridge->num, but the opposite doesn't hold (num
> doesn't give you the bridge without acquiring vme_buses_lock),
> it seems reasonable to me to take the bus_id as the input for
> both functions, because the requirements on the caller are lower.
> 

Patch 4 makes changes the struct vme_bridge to struct vme_dev. Looking at the
callers we are then effectively doing:

vme_bridge_get(vme_dev.id)

Then in vme_bridge_get(), looping through all the buses to find the one with
the correct id...

We could just pass in the struct vme_dev to both functions.

Martyn

> But the locking needs to be handled with care, see my reply
> to patch 5.
> 
> 		Emilio
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
