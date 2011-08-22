Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1HVMZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:25:08 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:43160 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1HVMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:25:03 -0400
Message-ID: <4E524A9B.7090700@ge.com>
Date: Mon, 22 Aug 2011 13:24:59 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: vme: add functions for bridge module refcounting
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch> <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch> <20110813074714.GA32149@flamenco.cs.columbia.edu>
In-Reply-To: <20110813074714.GA32149@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Aug 2011 12:21:25.0787 (UTC) FILETIME=[030CE6B0:01CC60C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/11 08:47, Emilio G. Cota wrote:
> On Fri, Aug 12, 2011 at 12:30:49 +0200, Manohar Vanga wrote:
>> +	struct vme_bridge *bridge;
>> +
>> +	mutex_lock(&vme_buses_lock);
>> +	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
>> +		if (bridge->num == bus_id) {
>> +			if (!bridge->owner)
>> +				dev_warn(bridge->parent,
>> +					"bridge->owner not set\n");
> 
> Don't do this; it will throw a false warning if the kernel is
> built without module support. Note that in that case
> 
> 	THIS_MODULE == (struct module *)0.
> 
> try_module_get() and module_put() do the right thing for all
> possible configs. Trust them.
> 

I can confirm that this does break when the bridge is compiled into the kernel.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
