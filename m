Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1AYXNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 18:13:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:32796 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1AYXNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 18:13:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=m+Z4Mm1NYa9kipug1lt0qCxKDApdYuV1XZDHdluEWGWysFPbCfuOC6CEXwcEQkqyUX
         Gx8ztnz7A6h28BVZ0c4A==
MIME-Version: 1.0
In-Reply-To: <20110125031752.GA9846@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com> <20110125031752.GA9846@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 25 Jan 2011 15:12:52 -0800
Message-ID: <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
To: Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 7:17 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jan 24, 2011 at 04:24:49PM -0800, Mike Waychison wrote:
>> +struct gsmi_ioctl {
>> +     uint16_t        length;         /* total length including data */
>> +     int             version;        /* structure version */
>> +     int             command;        /* ioctl command */
>
> Ick.  Use proper data types if you are going to create a new ioctl.
> Same goes for the structures above (hint, use __u32 and friends, not the
> unit??_t crap.
>
> I'd strongly suggest NOT creating a new ioctl though, that' just going
> to be a pain in the long run.

Ok.  I'll change these.  Even if the __u32 vs u32 vs uint32_t
differentiation is non-sense :(

>
>
>> +     union {
>> +             struct gsmi_get_nvram_var       get_nvram_var;
>> +             struct gsmi_get_next_var        get_next_var;
>> +             struct gsmi_set_nvram_var       set_nvram_var;
>> +             struct gsmi_set_event_log       set_event_log;
>> +             struct gsmi_clear_event_log     clear_event_log;
>> +     } gsmi_cmd;
>> +} __packed;
>> +
>> +#define GSMI_BASE                    'G'
>> +#define GSMI_IOCTL_VERSION           1
>> +#define GSMI_IOCTL                   _IOWR(GSMI_BASE, GSMI_IOCTL_VERSION, \
>> +                                         struct gsmi_ioctl)
>> +
>> +#endif /* _LINUX_GSMI_H */
>> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
>> index 18fd130..34f5dfa 100644
>> --- a/include/linux/miscdevice.h
>> +++ b/include/linux/miscdevice.h
>> @@ -40,6 +40,7 @@
>>  #define BTRFS_MINOR          234
>>  #define AUTOFS_MINOR         235
>>  #define MAPPER_CTRL_MINOR    236
>> +#define GOOGLE_SMI_MINOR     242
>>  #define MISC_DYNAMIC_MINOR   255
>
> Why make this a static number and not just use a dynamic one?

Well, we use static device numbers, which is why it has historically
been static as well.  Yes, that puts us squarely in the 1990s :)

I can change this guy too though.
