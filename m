Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab0ITXbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:31:37 -0400
Received: from kroah.org ([198.145.64.141]:33294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab0ITXbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:31:36 -0400
Date: Mon, 20 Sep 2010 16:29:21 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 2/2] staging: hv: Remove camel cases from vmbus channel
 functions
Message-ID: <20100920232921.GA31204@kroah.com>
References: <1FB5E1D5CA062146B38059374562DF7289E499E4@TK5EX14MBXC121.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7289E499E4@TK5EX14MBXC121.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 09:13:39PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Remove camel cases from vmbus channel functions
> Converted the function names, local variables to lower cases.

Nice try, but you can do better :)

>  /* Internal routines */
> -static int VmbusChannelCreateGpadlHeader(
> -	void *Kbuffer,	/* must be phys and virt contiguous */
> -	u32 Size,	/* page-size multiple */
> -	struct vmbus_channel_msginfo **msgInfo,
> -	u32 *MessageCount);
> -static void DumpVmbusChannel(struct vmbus_channel *channel);
> -static void VmbusChannelSetEvent(struct vmbus_channel *channel);
> +static int vmbuschannel_creategpadlheader(
> +	void *kbuffer,	/* must be phys and virt contiguous */
> +	u32 size,	/* page-size multiple */
> +	struct vmbus_channel_msginfo **msginfo,
> +	u32 *messagecount);
> +static void dumpvmbuschannel(struct vmbus_channel *channel);
> +static void vmbuschannel_setevent(struct vmbus_channel *channel);

Internal functions are that, internal, why the verbosity for them?  Why
not try the following:
	create_gpad_header()
	dump_channel()
	set_event()

Looks almost readable, right?

> -#if 0
> -static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)
> -{
> -	int i = 0;
> -	int j = 0;
> -
> -	DPRINT_DBG(VMBUS, "monitorPage - %p, trigger state - %d",
> -		   MonitorPage, MonitorPage->TriggerState);
> -
> -	for (i = 0; i < 4; i++)
> -		DPRINT_DBG(VMBUS, "trigger group (%d) - %llx", i,
> -			   MonitorPage->TriggerGroup[i].AsUINT64);
> -
> -	for (i = 0; i < 4; i++) {
> -		for (j = 0; j < 32; j++) {
> -			DPRINT_DBG(VMBUS, "latency (%d)(%d) - %llx", i, j,
> -				   MonitorPage->Latency[i][j]);
> -		}
> -	}
> -	for (i = 0; i < 4; i++) {
> -		for (j = 0; j < 32; j++) {
> -			DPRINT_DBG(VMBUS, "param-conn id (%d)(%d) - %d", i, j,
> -			       MonitorPage->Parameter[i][j].ConnectionId.Asu32);
> -			DPRINT_DBG(VMBUS, "param-flag (%d)(%d) - %d", i, j,
> -				MonitorPage->Parameter[i][j].FlagNumber);
> -		}
> -	}
> -}
> -#endif

Nice fix, but, it has nothing to do with the camelcase changes in this
file.

Please, again, one-patch-per-logical-change.  I'm getting tired of
repeating this...


>  /*
>   * VmbusChannelSetEvent - Trigger an event notification on the specified
>   * channel.
>   */
> -static void VmbusChannelSetEvent(struct vmbus_channel *Channel)
> +static void vmbuschannel_setevent(struct vmbus_channel *Channel)

You forgot to change the function comment name as well.

> -#if 0
> -static void VmbusChannelClearEvent(struct vmbus_channel *channel)
> -{
> -	struct hv_monitor_page *monitorPage;
> -
> -	if (Channel->OfferMsg.MonitorAllocated) {
> -		/* Each u32 represents 32 channels */
> -		clear_bit(Channel->OfferMsg.ChildRelId & 31,
> -			  (unsigned long *)gVmbusConnection.SendInterruptPage +
> -			  (Channel->OfferMsg.ChildRelId >> 5));
> -
> -		monitorPage =
> -			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
> -		monitorPage++; /* Get the child to parent monitor page */
> -
> -		clear_bit(Channel->MonitorBit,
> -			  (unsigned long *)&monitorPage->TriggerGroup
> -					[Channel->MonitorGroup].Pending);
> -	}
> -}
> -
> -#endif

Again a different thing than the case changing.

>  /*
> - * VmbusChannelGetDebugInfo -Retrieve various channel debug info
> + * vmbuschannel_getdebuginfo -Retrieve various channel debug info
>   */
> -void VmbusChannelGetDebugInfo(struct vmbus_channel *Channel,
> -			      struct vmbus_channel_debug_info *DebugInfo)
> +void vmbuschannel_getdebuginfo(struct vmbus_channel *channel,
> +			      struct vmbus_channel_debug_info *debuginfo)

Do you really need the vmbuschannel prefix here?

How about hyperv_get_debuginfo()?
Or vmbus_get_debuginfo()?

Although you might get vmbus confused with the vme bus, right?  Care to
find a consistant prefix for all hyperv bus functions and stick to it?

Oh, and what's wrong with "debug_info" instead of "debuginfo"?  You
alredy have it split up in the structure name, consistancy is good.


>  {
>  	struct hv_monitor_page *monitorPage;
> -	u8 monitorGroup = (u8)Channel->OfferMsg.MonitorId / 32;
> -	u8 monitorOffset = (u8)Channel->OfferMsg.MonitorId % 32;
> +	u8 monitorGroup = (u8)channel->OfferMsg.MonitorId / 32;
> +	u8 monitorOffset = (u8)channel->OfferMsg.MonitorId % 32;
>  	/* u32 monitorBit	= 1 << monitorOffset; */

Function name changes are one thing.

Variable names are another thing.

Again, one patch per thing please.

It's easier to read and verify that everything is sane.

Please try this one again.

thanks,

greg k-h
