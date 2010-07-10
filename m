Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab0GJVcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:32:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35285 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0GJVcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FCCAnc3xDjEk/2MxDtNNiyrs5obfqlXrb5krM3t570E+S7tyXb6fdD2MQWkrf9kFKs
         79XbndDLTABdlQRNzzw8QYzbv3Xb1VXedIoxoAcQE7uRCMmkoa/44GhoUGKOGKxv3cJm
         /n+TKQbneVsL30Qsya/E2gCaj4u+LKdt+LrMI=
MIME-Version: 1.0
In-Reply-To: <4C38E5D8.30408@zytor.com>
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi>
	<4C38DCD3.8020302@kernel.org>
	<AANLkTikNSrb3-o4F5YVPs_dvGi5xdGqM-P6w7OBZm6aH@mail.gmail.com>
	<4C38E5D8.30408@zytor.com>
Date: Sun, 11 Jul 2010 00:32:06 +0300
X-Google-Sender-Auth: jYN6Tf2UOgNNKlS6IGGWmT_Wdqs
Message-ID: <AANLkTinoUx_1NaBYtmSJ8Hdt5KyWAV-yLzwSX7ajqp9P@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 12:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/10/2010 02:17 PM, Pekka Enberg wrote:
>> On Sat, Jul 10, 2010 at 11:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> can you analyze "console=uart8250,io,0x3f8,115200n8" instead?
>>>
>>> that is equal to "earlyprintk=ttyS0,115200 console=ttyS0,115200"
>>>
>>> so we only use one for all.
>>>
>>> also like to kill earlyprintk=ttyS0,115200 to favor earlycon
>>
>> hpa, what's your take on this?
>>
>> The 'console' variant seems overly complicated to me. We can add it
>> but we also need to check for 'earlyprintk' as long as it's supported
>> by the kernel.
>>
>
> earlyprintk= seems to be preferred over console= these days.  Quite
> frankly it's idiotic to have the user enter as many low-level details as
> one has to do for the console= one.
>
> Now, as for the I/O base, the I/O base for legacy serial ports are
> available from a 4-element u16 array starting at absolute address 0x400.
>  I don't think Linux currently examines that array -- instead relying on
> the hard-coded values 0x3f8, 0x2f8, 0x3e8, 0x2e8 -- but it might
> something to consider for the future.  However, we should match the
> serial port subsystem there, of course.

OK. The current patch should match 'earlyprintk' handling which uses
hard-coded values only.
