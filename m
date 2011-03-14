Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1CNE7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 00:59:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1CNE7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 00:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KEZXC5AbNRTl0i3DcM4qLmszLTkY9DjCwYzrhqTtjCm2TXEmot8eRsu4oe4QRCj6X4
         unMj+r+Ccnvd9PxePmZA==
MIME-Version: 1.0
In-Reply-To: <4D7D9F92.5010604@kernel.org>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com> <4D7D9F92.5010604@kernel.org>
From: Tim Hockin <thockin@google.com>
Date: Sun, 13 Mar 2011 21:58:21 -0700
Message-ID: <AANLkTik5iAPou_bPa4xk6iR27sOk2yrexaaTUe-g=VEe@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Mike Waychison <mikew@google.com>, Greg KH <greg@kroah.com>,
        Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        San Mehat <san@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Sufficient" or not, that's how the BIOSes we've got work.  We can't
retrofit that.

On Sun, Mar 13, 2011 at 9:54 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> On 03/11/2011 05:43 PM, Mike Waychison wrote:
>> This patch introduces the 'memconsole' driver.
>>
>> Our firmware gives us access to an in-memory log of the firmware's
>> output.   This gives us visibility in a data-center of headless machines
>> as to what the firmware is doing.
>>
>> The memory console is found by the driver by finding a header block in
>> the EBDA.  The buffer is then copied out, and is exported to userland in
>> the file /sys/firmware/log.
>>
>
> OK, I really don't like this.
>
> All it has is a 32-bit nonrandom signature, no DMI keying or anything
> else to protect it.  This really isn't sufficient.
>
>        -hpa
>
