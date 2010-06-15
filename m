Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0FOQXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:23:08 -0400
Received: from claw.goop.org ([74.207.240.146]:32782 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab0FOQXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:23:06 -0400
Message-ID: <4C17A8B2.3050203@goop.org>
Date: Tue, 15 Jun 2010 17:22:10 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, ddutile@redhat.com,
       sheng@linux.intel.com
Subject: Re: [Xen-devel] [PATCH 06/12] Allow xen platform pci device to be
 compiled as a module
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-6-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212046.GD8600@phenom.dumpdata.com>
In-Reply-To: <20100614212046.GD8600@phenom.dumpdata.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 10:20 PM, Konrad Rzeszutek Wilk wrote:
>> -static inline unsigned int max_nr_grant_frames(void)
>> +unsigned int gnttab_max_nr_grant_frames(void)
>>  {
>>  	unsigned int xen_max = __max_nr_grant_frames();
>>  
>> @@ -444,6 +445,7 @@ static inline unsigned int max_nr_grant_frames(void)
>>  		return boot_max_nr_grant_frames;
>>  	return xen_max;
>>  }
>> +EXPORT_SYMBOL_GPL(gnttab_max_nr_grant_frames);
>>     
> Prefix the name with 'xen_' ? That is a mouthfull thought:
>
> Xen Grant Table Max Nr Grant Frames. How about 'xen_gnttab_max_frames' ?
>   

Unfortunately the gnttab API is generally lacking xen_ prefixes.  It's
better to keep this consistent, and then maybe sort them all out together.

    J

