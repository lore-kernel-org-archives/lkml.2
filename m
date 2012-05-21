Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2EUXFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:05:03 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:9695 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2EUXFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:05:01 -0400
Message-ID: <4FBACA14.5090804@suse.com>
Date: Mon, 21 May 2012 16:04:52 -0700
From: Lee Duncan <lduncan@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kai.makisara@kolumbus.fi, jeffm@suse.com
Subject: Re: [PATCH 1/5] st: Use static class attributes
References: <4FB476DD.4020107@suse.com> <20120518025146.GB19158@parisc-linux.org>
In-Reply-To: <20120518025146.GB19158@parisc-linux.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff would normally reply to this, since it is his patch, but he is
otherwise occupied right now, so I will respond.

On 05/17/2012 07:51 PM, Matthew Wilcox wrote:
> On Wed, May 16, 2012 at 08:56:13PM -0700, Lee Duncan wrote:
>> @@ -84,7 +84,8 @@ static int try_wdio = 1;
>>  static int st_dev_max;
>>  static int st_nr_dev;
>>  
>> -static struct class *st_sysfs_class;
>> +extern struct class st_sysfs_class;
> 
> Umm ... 'extern' ...
> 
>> @@ -4283,6 +4284,11 @@ static void scsi_tape_release(struct kref *kref)
>>  	return;
>>  }
>>  
>> +struct class st_sysfs_class = {
>> +	.name = "scsi_tape",
>> +	.dev_attrs = st_dev_attrs,
>> +};
> 
> ... and then you define it?
> 
> I think you meant to say "struct class st_sysfs_class;" at the top,
> and then later:
> 
> static struct class st_sysfs_class = {
> ...
> 
>> +struct device_attribute st_dev_attrs[] = {
> 
> Should also be static
> 
> 

The compiler (gcc 4.6.2) does not accept a forward declaration that does
not match the data definition. When I tried your suggestion, the
compiler complained that the two declarations did not match, but it
accepted it if both the forward declaration and the data declaration are
"static".

I'll resubmit v3 of the patch set with this change.
-- 
Lee Duncan
SUSE Labs
