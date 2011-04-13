Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab1DMK7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:59:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44388 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1DMK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=BeY6lVDnSnDRUGesWLZDDDrGvktu5A7hXLvejnvQg1x7bOJlrhkSzrTvPqvVJW1Mne
         AsD3VokXbgirIPIi4uefeVuLd1u6Gcr4QjVL3P6DXanPvbac9mw7VCfBwFe5ssfpY6u3
         yt7hQ5esPrruSfktgcLSCaoTd3Mi2V7FjX+wk=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Sergei Shtylyov" <sshtylyov@mvista.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Tatyana Brokhman" <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, balbi@ti.com, ablay@codeaurora.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb/gadget: don't deploy SS descriptors if SS is not
 enabled.
References: <20110411175917.GE4018@linutronix.de>
 <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
 <1302636896-12717-5-git-send-email-bigeasy@linutronix.de>
 <4DA57F0F.1090609@ru.mvista.com> <4DA58179.40004@linutronix.de>
Date: Wed, 13 Apr 2011 12:59:39 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtvh5phh3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4DA58179.40004@linutronix.de>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 12:56:57 +0200, Sebastian Andrzej Siewior  
<bigeasy@linutronix.de> wrote:

> Sergei Shtylyov wrote:
>> Hello.
>
> Hello Sergei,
>
>> Cleaned-up example:
>>  (in header)
>>     #ifndef CONFIG_NET_FUNKINESS
>>     static inline void init_funky_net (struct net_device *d) {}
>>     #endif
>>  (in the code itself)
>>     dev = alloc_etherdev (sizeof(struct funky_private));
>>     if (!dev)
>>         return -ENODEV;
>>     init_funky_net(dev);
>
> The problem here is that the code is included via
>
>    #include "composite.c
>
> so we don't really use header files. The alternative would be to use the
> gadget_is_super_speed() function but that one takes a gadget as argument.
> Preferences?

#ifdef CONFIG_USB_GADGET_SUPERSPEED
void usb_create_ss_descriptors(struct usb_function *f)
{
	/* ... */
}
#else
static inline void usb_create_ss_descriptors(struct usb_function *f) { }
#endif

Is usually preferred.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
