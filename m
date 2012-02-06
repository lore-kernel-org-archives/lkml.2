Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2BFAxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 19:53:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61273 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab2BFAxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 19:53:20 -0500
Message-ID: <4F2F2445.9080604@cn.fujitsu.com>
Date: Mon, 06 Feb 2012 08:52:21 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Luben Tuikov <ltuikov@yahoo.com>
CC: Willy Tarreau <w@1wt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 32/91] libsas: remove expander from dev list on error
References: <20120205220950.812864962@pcw.home.local> <4C7B5EA1-AE40-4E64-92CC-24277900A99E@yahoo.com>
In-Reply-To: <4C7B5EA1-AE40-4E64-92CC-24277900A99E@yahoo.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-06 08:51:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-06 08:51:53,
	Serialize complete at 2012-02-06 08:51:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 07:48 AM, Luben Tuikov wrote:

> Isn't this my patch? Are you submitting it as your own?


No, he just wanna backport to the stable.

> 
>         Luben
> 
> 
> On Feb 5, 2012, at 14:10, Willy Tarreau <w@1wt.eu> wrote:
> 
>> 2.6.27-longterm review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>>
>> commit 5911e963d3718e306bcac387b83e259aa4228896 upstream.
>>
>> If expander discovery fails (sas_discover_expander()), remove the
>> expander from the port device list (sas_ex_discover_expander()),
>> before freeing it. Else the list is corrupted and, e.g., when we
>> attempt to send SMP commands to other devices, the kernel oopses.
>>
>> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>> Reviewed-by: Jack Wang <jack_wang@usish.com>
>> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>> ---
>> drivers/scsi/libsas/sas_expander.c |    3 +++
>> 1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> Index: longterm-2.6.27/drivers/scsi/libsas/sas_expander.c
>> ===================================================================
>> --- longterm-2.6.27.orig/drivers/scsi/libsas/sas_expander.c    2012-02-05 22:34:34.059914940 +0100
>> +++ longterm-2.6.27/drivers/scsi/libsas/sas_expander.c    2012-02-05 22:34:39.404915902 +0100
>> @@ -839,6 +839,9 @@
>>
>>    res = sas_discover_expander(child);
>>    if (res) {
>> +        spin_lock_irq(&parent->port->dev_list_lock);
>> +        list_del(&child->dev_list_node);
>> +        spin_unlock_irq(&parent->port->dev_list_lock);
>>        kfree(child);
>>        return NULL;
>>    }
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


