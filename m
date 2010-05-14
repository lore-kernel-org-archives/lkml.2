Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0ENFcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:32:09 -0400
Received: from mga05.intel.com ([192.55.52.89]:42395 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159Ab0ENFcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:32:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="798358935"
Message-ID: <4BECE052.5020907@linux.intel.com>
Date: Fri, 14 May 2010 13:32:02 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.co" <ak@linux.intel.co>,
       "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
References: <20100513114835.GD2169@shaohui> <4BECC418.2080602@linux.intel.com> <20100514041136.GA12020@localhost>
In-Reply-To: <20100514041136.GA12020@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
>> Pls. replace it with following code:
>>
>> +#ifdef CONFIG_NODE_HOTPLUG_EMU
>> +static ssize_t store_nodes_probe(struct sysdev_class *class,
>> +                                 struct sysdev_class_attribute *attr,
>> +                                 const char *buf, size_t count)
>> +{
>> +       long nid;
>> +       int ret;
>> +
>> +       ret = strict_strtol(buf, 0, &nid);
>> +       if (ret == -EINVAL)
>> +               return ret;
>> +
>> +       ret = hotadd_hidden_nodes(nid);
>> +       if (!ret)
>> +               return count;
>> +       else
>> +               return -EIO;
>> +}
>> +#endif
> 
> How about this?
> 
>        err = strict_strtol(buf, 0, &nid);
>        if (err < 0)
>                return err;

other negative value would be odd here.

>        err = hotadd_hidden_nodes(nid);
>        if (err < 0)
>                return err;

hotadd_hidden_nodes could return -EEXIST, which is also odd here, right?

>        return count;
> 
> Thanks,
> Fengguang

