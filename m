Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1IWGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:41:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:48706 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab1IWGl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:41:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,427,1312182000"; 
   d="scan'208";a="54484440"
Message-ID: <4E7C2A15.80703@linux.intel.com>
Date: Fri, 23 Sep 2011 14:41:25 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org, mikew@google.com,
        saguchi@redhat.com
Subject: Re: [PATCH] efi: Avoid sysfs spew on reboot and panic
References: <1316552853-2000-1-git-send-email-mjg@redhat.com> <4E795A9C.4040508@linux.intel.com> <20110921124018.GA22155@srcf.ucam.org> <4E7A9BC6.9070608@linux.intel.com> <20110922131504.GA11990@srcf.ucam.org>
In-Reply-To: <20110922131504.GA11990@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/9/22 21:15, Matthew Garrett 写道:
> On Thu, Sep 22, 2011 at 10:21:58AM +0800, Chen Gong wrote:
>> 于 2011/9/21 20:40, Matthew Garrett 写道:
>>> On Wed, Sep 21, 2011 at 11:31:40AM +0800, Chen Gong wrote:
>>>>>   	mutex_lock(&psinfo->buf_mutex);
>>>>>   	memcpy(psinfo->buf, buf, size);
>>>>> -	id = psinfo->write(type, 0, size, psinfo);
>>>>> +	id = psinfo->write(type, 0, KMSG_DUMP_UNKNOWN, size, psinfo);
>>>>
>>>> I can't say it is wrong because no real caller for this function, but I can't
>>>> say it is right, yet. KMSG_DUMP_UNKNOWN here looks too arbirary. Do you have
>>>> any reason to use this type here ?
>>>
>>> If a function calls pstore_write() directly then we have no type to
>>> associate with it. It seems worth making this explicit.
>>
>> Yep, that's the point. We hope to get a more reasonable method to do it, not
>> any assumption.
>
> I'm afraid I don't understand. Could you give an example of how you
> think this should look?
>
If you insist on your design, I prefer deleting the function pstore_write before 
applying your patch. We all know no real users to call this function,
every backend will register Its own callback, so this function is useless at all.
