Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab1BKCTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 21:19:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:12723 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab1BKCTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 21:19:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=bY/JztEB0Nf4b0k4CLt5ITRHnjMGryKISggtKKR6YG1Ol031+FcacztMJFIy8pQ5/4
         OLRm3/9ObTcGuK1mzYOg==
Message-ID: <4D549CC3.4050902@google.com>
Date: Thu, 10 Feb 2011 18:19:47 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tim Hockin <thockin@google.com>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
References: <4D547236.6080702@google.com> <20110211012552.GA28995@kroah.com>
In-Reply-To: <20110211012552.GA28995@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/11 17:25, Greg KH wrote:
> On Thu, Feb 10, 2011 at 03:18:14PM -0800, Mike Waychison wrote:
>> Hey guys,
>>
>> I need some guidance. Do either of you know of any attempts to have
>> the kernel decode and display/interact with DMI type 15: System
>> Event Log?
>
> I don't have any experience in this area, but I do have one comment on
> your proposal below:
>
>> The event log I'm dealing with while cleaning up the "gsmi" driver
>> interacts with a log that is modeled after the System Event Log.
>> I'm wondering if there is any precedent for a clean way to expose
>> the event log, I'd like to use it (replacing the ioctls from my
>> earlier patch series send-out).
>>
>> FYI, we use OEM specific headers and descriptors, which probably
>> doesn't help.
>>
>> Do most folks that need access to this data rely on /dev/mem and
>> dmidecode?  I'd like to avoid going that route if possible.
>>
>> Lacking any better ideas though, I was thinking of something along
>> the lines of the following:
>>
>>
>> $ cat /sys/firmware/gsmi/eventlog
>> <offset>  <boot number>  <recorded time>  <quoted reason>  <optional data>
>> ...
>>
>> with a single event log entry per line.
>>    <offset>  would be the record number,
>>    <boot number>  is the recorded boot number
>>    <recorded time>  comes from each record,
>>    <quoted reason>  is the English translation of Event Log Types from
>> the DMTF standard + vendor extended types we use.
>>    <optional data>  is space separated values associated with<quoted reason>
>
> Ick, no, remember, sysfs is "one value per file".  doing even a single
> line like you describe here isn't ok, not to mention a huge buffer of
> these lines.
>
> And no, a "binary" sysfs file is not ok either.

Works fine for the /sys/firmware/efi stuff.  Works well enough for 
/sys/firmware/acpi too.

>
> Now your idea for such a log file is fine, I'm not saying that's not ok,
> or acceptable, just don't put it in sysfs, sorry.  Try using the ring
> buffer framework from the tracing code perhaps?
>
> Or use debugfs?  Or make a 'firmwarefs'?  I can easily knock that
> together if you need it.

Are you seriously asking for another filesystem?

I don't get why you're holding me to these standards that that are 
totally missed by these same subsystems that you maintain.

