Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab0LHEzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:55:49 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:42981 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0LHEzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:55:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lRUpT8hpplqDIqYztv50JAx5GOZ02YC8fFR5sv4jYqAhGsmPp8FN5BNWzQQ/snG0NS
         dQCHdEWQNjJllFMPe8B9NlaV77XedaFo12hZOQqsPedTiXNCcjLIpT2R1qxk+zilWUzd
         NfNRCNw80hAgjy6V2ols2crAEqAyQcC3lCndQ=
MIME-Version: 1.0
In-Reply-To: <597621.83948.qm@web31707.mail.mud.yahoo.com>
References: <712019.56679.qm@web31702.mail.mud.yahoo.com>
	<4CFEE38E.3020500@gmail.com>
	<597621.83948.qm@web31707.mail.mud.yahoo.com>
Date: Tue, 7 Dec 2010 22:55:47 -0600
Message-ID: <AANLkTi=V_MD5MqkPfBSD0P+J0vYgS3nwHZA37SOvYW-Z@mail.gmail.com>
Subject: Re: Posted Write onto a PCI end point device using Linux
From: Robert Hancock <hancockrwd@gmail.com>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 9:57 PM, Sanka Piyaratna <cesanka@yahoo.com> wrote:
> Hi Robert,
> Could you please tell me how I can initiate a posted write towards a PCIe
> endpoint with larger than 32 bit payload using Linux?
> Thanks and regards,

You can try writeq to get a 64-bit payload, but I don't think it's
available on all platforms. In particular with a 32-bit CPU, it may
not be possible at all. If you need to send bigger payloads then you
need to use DMA.

>
> Sanka Piyaratna
>
> ________________________________
> From: Robert Hancock <hancockrwd@gmail.com>
> To: Sanka Piyaratna <cesanka@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Wed, 8 December, 2010 12:16:54 PM
> Subject: Re: Posted Write onto a PCI end point device using Linux
>
> On 12/07/2010 05:29 AM, Sanka Piyaratna wrote:
>> Hi,
>>
>>
>> I am wondering whether it is possible to issue a posted write using the
>> host
>> computer's root complex towards an PCI express end point. I have done this
>> using
>>
>> DMA in the past. However, if posted writes are possible that would save a
>> lot of
>>
>> time and effort and would be quicker too.
>
> Writes from the CPU to PCI memory are always posted. However, the posted
> write buffer size is usually quite limited and so this probably will
> still cause CPU overhead when writing any significant amount of data
> this way.
>
>
