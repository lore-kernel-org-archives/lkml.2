Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab0D3QvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:51:21 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:52645 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab0D3QvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pwJztwdMGCUktO82DfTLZO+fTJ2cnWZRRyXdkqP8OcMxRqFHxZCE/G8XepfWrl+f01
         Muvt/UsrdLZSKpxyAQ912ft8r3ew3j+Q0kllnmqzDFQIQhBCVqG9Ngf/8Kfwj8O6SF3h
         bn7QyWcEa83YNe9LUA7Wza/7vSfelLAg0rEBE=
MIME-Version: 1.0
In-Reply-To: <20100429151555.GM17639@pcarmody-desktop>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
	 <1272399798.2255.2.camel@localhost>
	 <1272400246.2255.5.camel@localhost>
	 <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
	 <20100429151555.GM17639@pcarmody-desktop>
Date: Thu, 29 Apr 2010 10:52:45 -0500
Message-ID: <y2xe6bf505b1004290852xa079969k3316c5bb7233de13@mail.gmail.com>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 10:15 AM, Phil Carmody
<ext-phil.2.carmody@nokia.com> wrote:
> On 28/04/10 19:54 +0200, ext Xianghua Xiao wrote:
>> On Wed, Apr 28, 2010 at 11:34 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> ...
>> Thomas,
>> I patched it and re-run it however did not find any condition from
>> your patch had a hit.
>> In your patch I changed :
>>
>> if (!file->f_path) {
>> to
>> if(!(&(file->f_path))){
>> Otherwise it won't compile as f_path is a not a pointer.
>
> That check is completely bogus. The address of _anything_ (whose address
> can be taken) is _always_ non-null.
>
> Phil
>

Thomas,

I confirm that 2.6.33.3-rt15 worked fine, reboot/umount will not oops.

Thanks,
Xianghua
