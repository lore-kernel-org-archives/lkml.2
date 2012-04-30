Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2D3QrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:47:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab2D3QrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:47:08 -0400
Message-ID: <4F9EC206.30501@redhat.com>
Date: Mon, 30 Apr 2012 13:47:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH v2] edac_mc: Cleanup per-dimm_info debug messages
References: <4F9E9958.6010606@redhat.com>  <1335798160-9879-1-git-send-email-mchehab@redhat.com> <1335802560.22209.2.camel@joe2Laptop>
In-Reply-To: <1335802560.22209.2.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 13:16, Joe Perches escreveu:
> On Mon, 2012-04-30 at 12:02 -0300, Mauro Carvalho Chehab wrote:
>> The edac_mc_alloc() routine allocates one dimm_info device for all
>> possible memories, including the non-filled ones. The debug messages
>> there are somewhat confusing. So, cleans them, by moving the code
>> that prints the memory location to edac_mc, and using it on both
>> edac_mc_sysfs and edac_mc.
> []
>> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> []
>> @@ -40,6 +40,25 @@
>>  static DEFINE_MUTEX(mem_ctls_mutex);
>>  static LIST_HEAD(mc_devices);
>>  
>> +unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
>> +			         int len)
>> +{
>> +	struct mem_ctl_info *mci = dimm->mci;
>> +	int i, n, count = 0;
>> +	char *p = buf;
>> +
>> +	for (i = 0; i < mci->n_layers; i++) {
>> +		n = snprintf(p, len, "%s %d ",
>> +			      edac_layer_name[mci->layers[i].type],
>> +			      dimm->location[i]);
>> +		p += n;
>> +		len -= n;
>> +		count += n;
>> +	}
> 
> I believe this snprintf can be unsafe
> when the buffer length len is exceeded.
> 
> if len is negative, it's promoted to size_t
> and continues to write into p.

Ok, I've changed it to unsigned at the new version and added a break
to prevent this condition to happen. Version 3 with this fix and some
other improvements were sent.

Yet, this condition will never happen, in practice, as the edac core
currently supports only 3 layers.

Regards,
Mauro.
