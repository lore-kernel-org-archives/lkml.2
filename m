Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1FHUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:51:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:19503 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab1FHUvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,339,1304319600"; 
   d="scan'208";a="15749137"
Message-ID: <4DEFE0C9.10206@intel.com>
Date: Wed, 08 Jun 2011 13:51:21 -0700
From: Kiran Patil <kiran.patil@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>
Subject: Re: [SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target
 (TCM - target core) support
References: <201105202102.p4KL28Io025077@hera.kernel.org> <BANLkTimLbj1FHy9j56ScRGwc2t6Ci+QhAw@mail.gmail.com>
In-Reply-To: <BANLkTimLbj1FHy9j56ScRGwc2t6Ci+QhAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Response in-line.

On 6/8/2011 1:10 PM, Geert Uytterhoeven wrote:
>>     [SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target (TCM - target core) support
>>
>>     This is a comprehensive patch for FC-FC4 provider. tcm_fc is a FC-FC4
>>     provider which glues target core (TCM) with Fiber channel library
>>     (libfc). tcm_fc uses existing FC4 provider hooks from Fiber channel
>>     library. This Fiber channel library is used by FCoE (transport - FC
>>     over Ethernet) protocol driver as well.
>> --- /dev/null
>> +++ b/drivers/target/tcm_fc/tfc_conf.c
>> +static int __init ft_init(void)
>> +{
>> +       if (ft_register_configfs())
>> +               return -1;
>> +       if (fc_fc4_register_provider(FC_TYPE_FCP,&ft_prov)) {
>> +               ft_deregister_configfs();
>> +               return -1;
>> +       }
>> +       blocking_notifier_chain_register(&fc_lport_notifier_head,&ft_notifier);
>> +       fc_lport_iterate(ft_lport_add, NULL);
>> +       return 0;
>> +}
>> +
>> +static void __exit ft_exit(void)
>> +{
>> +       blocking_notifier_chain_unregister(&fc_lport_notifier_head,
>> +&ft_notifier);
>> +       fc_fc4_deregister_provider(FC_TYPE_FCP,&ft_prov);
>> +       fc_lport_iterate(ft_lport_del, NULL);
>> +       ft_deregister_configfs();
>> +       synchronize_rcu();
>> +}
>> +
>> +#ifdef MODULE
>> +MODULE_DESCRIPTION("FC TCM fabric driver " FT_VERSION);
>> +MODULE_LICENSE("GPL");
>> +module_init(ft_init);
>> +module_exit(ft_exit);
>> +#endif /* MODULE */
> If CONFIG_TCM_FC=y, this gives:
>
> | drivers/target/tcm_fc/tfc_conf.c:642: warning: ‘ft_init’ defined but not used
>
> Shouldn't the #ifdef MODULE and #endif just be removed?
Agree. Will get it fixed.
> Who else initializes this module if it's builtin?
> E.g. ft_register_configfs() is global, but not used outside this source file?
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
Thanks
-- KIran P.
